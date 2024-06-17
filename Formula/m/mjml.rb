require "language/node"

class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-4.15.3.tgz"
  sha256 "1918171314f07c1283a84f24bbf6e9cd1325906d48722b26a4b901f0eea00176"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64d69529fb3fe96f881c82d4c47a3b72685aa3a34b83382444c54e9fc2dc51d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64d69529fb3fe96f881c82d4c47a3b72685aa3a34b83382444c54e9fc2dc51d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d69529fb3fe96f881c82d4c47a3b72685aa3a34b83382444c54e9fc2dc51d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2714ac758656a73a6fdffa5aa9e3c49dc201c9f576ca8c7c93502d3538b4eeca"
    sha256 cellar: :any_skip_relocation, ventura:        "2714ac758656a73a6fdffa5aa9e3c49dc201c9f576ca8c7c93502d3538b4eeca"
    sha256 cellar: :any_skip_relocation, monterey:       "2714ac758656a73a6fdffa5aa9e3c49dc201c9f576ca8c7c93502d3538b4eeca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c5aade520e88337c5f63a724fd87e092542806bcb360979740128db65e0f538"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
