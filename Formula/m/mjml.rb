class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-5.2.0.tgz"
  sha256 "29084c6ec9ce352afca46d4aeabfb214de26237b2e7d0ebcef0617d9c03642a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "248cb1f57ddabffeef323e113573663fdd69a3203308d8d48f5b1645b1eed197"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df8399d7d182f2d06bf2008a3385a7f727ff0eae0126c872ebad2a185e98ba53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df8399d7d182f2d06bf2008a3385a7f727ff0eae0126c872ebad2a185e98ba53"
    sha256 cellar: :any_skip_relocation, sonoma:        "10be6f2cf5d2d6e0f9630647cd3e5f9e004ba1cb2121b584ea0922dbbccfc056"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64478fb5f11df9d0f577faf8c3ef9618befb3efb92bf33c3769d43fb135e49d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64478fb5f11df9d0f577faf8c3ef9618befb3efb92bf33c3769d43fb135e49d3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/mjml/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    (testpath/"input.mjml").write <<~EOS
      <mjml>
        <mj-body>
          <mj-section>
            <mj-column>
              <mj-text>
                Hello Homebrew!
              </mj-text>
            </mj-column>
          </mj-section>
        </mj-body>
      </mjml>
    EOS
    compiled_html = shell_output("#{bin}/mjml input.mjml")
    assert_match "Hello Homebrew!", compiled_html

    assert_equal <<~EOS, shell_output("#{bin}/mjml --version")
      mjml-core: #{version}
      mjml-cli: #{version}
    EOS
  end
end
