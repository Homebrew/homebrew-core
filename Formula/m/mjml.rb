class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-4.15.3.tgz"
  sha256 "1918171314f07c1283a84f24bbf6e9cd1325906d48722b26a4b901f0eea00176"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "fc01447be6e0fd81d673d37952632cbf146f101ab9a117aaf31527c795550ad8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
