class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-5.3.0.tgz"
  sha256 "e9504d7fc6130bf016e5ef40d2ce0ed104b6ba5f43a4f890ed6f5cf4f46a75c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cd2dfc0545a9ee0ff33b375c6e0259534182bfdb75c37ae5e0305fbb950fce60"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"input.mjml").write <<~HTML
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
    HTML
    compiled_html = shell_output("#{bin}/mjml input.mjml")
    assert_match "Hello Homebrew!", compiled_html

    assert_equal <<~EOS, shell_output("#{bin}/mjml --version")
      mjml-core: #{version}
      mjml-cli: #{version}
    EOS
  end
end
