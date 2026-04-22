class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-5.0.1.tgz"
  sha256 "08796748d17e3df5f95277484e15ddfa9467ee15c0eff6b6d3c49b4d8c7a80a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96b276ab17177671ae3c418e56253711dbdba1104127202a52b67d2357f68581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6e4a2c0b3a193fe6f3586a94d71cc16517c5170ff188b4535e009d524335cb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e4a2c0b3a193fe6f3586a94d71cc16517c5170ff188b4535e009d524335cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f35022c77f02db0ca167cd4af272bd20934c187d7897519a107e4db4081f3c3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55935f3ecb4e7b06def62e9b44fbf303f4035e8918d4dfd66303d54d3a18f205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55935f3ecb4e7b06def62e9b44fbf303f4035e8918d4dfd66303d54d3a18f205"
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
