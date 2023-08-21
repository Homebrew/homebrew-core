require "language/node"

class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-4.14.1.tgz"
  sha256 "fb9ebe982773f05711ab7da2d26fcf4eb11e50e44a6e8d12ef354b6f6057867d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b455e25e7a59b43ccf662c88aba0bd03f8ef7916147dc1aeb3e7df3220bad0d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b455e25e7a59b43ccf662c88aba0bd03f8ef7916147dc1aeb3e7df3220bad0d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b455e25e7a59b43ccf662c88aba0bd03f8ef7916147dc1aeb3e7df3220bad0d7"
    sha256 cellar: :any_skip_relocation, ventura:        "0c3fa66cdaae582eb8fb5971b7ec41475af85133f779f1ea824e1bb9492e968b"
    sha256 cellar: :any_skip_relocation, monterey:       "0c3fa66cdaae582eb8fb5971b7ec41475af85133f779f1ea824e1bb9492e968b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c3fa66cdaae582eb8fb5971b7ec41475af85133f779f1ea824e1bb9492e968b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19167babb492a099bfa30b6d2584c25456d5497bed3ebbda230b04b532f16adb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos libexec/"lib/node_modules/mjml/node_modules/fsevents/fsevents.node"
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
