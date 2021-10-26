require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.50.1.tar.gz"
  sha256 "23af169410f5e25414b444d85f346f304ce2e494fe2c3c034cdf256e02e22218"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5038d62fe32f3617495a701e756b1fc272574dedcf6ea0cb90c4ee6c6b991d3d"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a9e988f0c0a8f4889c4ca69fc0078c206d6a2de487e422401d96913139cfb85"
    sha256 cellar: :any_skip_relocation, catalina:      "5a9e988f0c0a8f4889c4ca69fc0078c206d6a2de487e422401d96913139cfb85"
    sha256 cellar: :any_skip_relocation, mojave:        "5a9e988f0c0a8f4889c4ca69fc0078c206d6a2de487e422401d96913139cfb85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4faeb7dc6fdeaac856167dcd0f56425d7a4d472a1c6ea06845292166f1a5f02c"
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
