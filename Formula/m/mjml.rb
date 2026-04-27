class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-5.1.0.tgz"
  sha256 "e72facfbb4bf0e6e7b157228824e66fc2db5e0b54e49d22721e6496b72534765"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfee88165dd2a915bd46af6b5c4759642b02c5dd6f9148fef290aadcb3674c82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e95b94ef98c7333e50582b868b26e1ca5fd8b58ac39b133a73dd18b284815b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95b94ef98c7333e50582b868b26e1ca5fd8b58ac39b133a73dd18b284815b10"
    sha256 cellar: :any_skip_relocation, sonoma:        "456686f7ba28d90d601267b8a78e30b63c431ce133c104be79b7585b01e9986f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bdb54a1442628ca7b25b50ea40793ae74a9f4a2e350197461efc790391c6d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bdb54a1442628ca7b25b50ea40793ae74a9f4a2e350197461efc790391c6d54"
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
