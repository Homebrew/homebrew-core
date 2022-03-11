require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.50.5.tar.gz"
  sha256 "78ad15b382421678195a519fff0502f070d8d5915be0027aa51d2e94c04dfe62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee087d449eadb72afdf63a5a6802d048b61476e9be1a8c91205cd799f5f19f44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee087d449eadb72afdf63a5a6802d048b61476e9be1a8c91205cd799f5f19f44"
    sha256 cellar: :any_skip_relocation, monterey:       "09b2818a95cbaa2ca6dd8116f4e2f2d94a27f2ede4d50a3e36be262a450cf656"
    sha256 cellar: :any_skip_relocation, big_sur:        "09b2818a95cbaa2ca6dd8116f4e2f2d94a27f2ede4d50a3e36be262a450cf656"
    sha256 cellar: :any_skip_relocation, catalina:       "09b2818a95cbaa2ca6dd8116f4e2f2d94a27f2ede4d50a3e36be262a450cf656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71d5d25e220a6efde42258cc57c8164a4be7c363193a6aefb327d0bfc9b3c60"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Extract native slices from universal binaries
    deuniversalize_machos
  end

  test do
    (testpath/"api.go").write <<~EOS
      /**
       * @api {get} /user/:id Request User information
       * @apiVersion #{version}
       * @apiName GetUser
       * @apiGroup User
       *
       * @apiParam {Number} id User's unique ID.
       *
       * @apiSuccess {String} firstname Firstname of the User.
       * @apiSuccess {String} lastname  Lastname of the User.
       */
    EOS
    (testpath/"apidoc.json").write <<~EOS
      {
        "name": "brew test example",
        "version": "#{version}",
        "description": "A basic apiDoc example"
      }
    EOS
    system bin/"apidoc", "-i", ".", "-o", "out"
    assert_predicate testpath/"out/assets/main.bundle.js", :exist?
  end
end
