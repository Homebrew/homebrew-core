require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.50.5.tar.gz"
  sha256 "78ad15b382421678195a519fff0502f070d8d5915be0027aa51d2e94c04dfe62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e966cb24c07275c508f2d2f998a648454d144440a79da70cf7ce2c2c5f0efd78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e966cb24c07275c508f2d2f998a648454d144440a79da70cf7ce2c2c5f0efd78"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a1a09b224fdfb53f87ef1906320b869b9246e6dbec494139c6895cedde8cfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5a2ec5e06bce49a3153e7d25ca0facaaa041081001b752ad443b6aeae154ae4"
    sha256 cellar: :any_skip_relocation, catalina:       "b8a1a09b224fdfb53f87ef1906320b869b9246e6dbec494139c6895cedde8cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5e4651f3f732dcb68ff1f5e686b1aa2d3ad4c734720466c3b5601b91717db1f"
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
