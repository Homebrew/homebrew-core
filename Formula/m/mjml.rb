class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-4.15.3.tgz"
  sha256 "1918171314f07c1283a84f24bbf6e9cd1325906d48722b26a4b901f0eea00176"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bcde646a47d51238258b06388c69a52115f850eef26ea76c218ad5e7318a2f57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a681f3fa1b9bfc3159325c2faa63b1cbe148e94d4cfd1a2b2c94587c30b25de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a681f3fa1b9bfc3159325c2faa63b1cbe148e94d4cfd1a2b2c94587c30b25de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a681f3fa1b9bfc3159325c2faa63b1cbe148e94d4cfd1a2b2c94587c30b25de"
    sha256 cellar: :any_skip_relocation, sonoma:         "464b8c2813c2c1a80ac3f4b91fbb5fc3e2a9e189191ee6858c210d0674e00868"
    sha256 cellar: :any_skip_relocation, ventura:        "464b8c2813c2c1a80ac3f4b91fbb5fc3e2a9e189191ee6858c210d0674e00868"
    sha256 cellar: :any_skip_relocation, monterey:       "464b8c2813c2c1a80ac3f4b91fbb5fc3e2a9e189191ee6858c210d0674e00868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7056b342d8ea37e7da098cc2b2cc3764d3a418e5d36d3d2f07058f634fe12b2"
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
