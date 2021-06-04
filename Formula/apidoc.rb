require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.28.1.tar.gz"
  sha256 "f4ed7813ce5e365c9457dfa9414c7750328965963cc9f1a9ef66baad66071677"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "691c510e0dacb3e2689f8daa34abe79f7b37d35100bebe354ccdd888cab2a406"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e192f37c90cf6fcae84119e0e356fa84435274d3bda3fee85b9d24a8f3bf1cd"
    sha256 cellar: :any_skip_relocation, catalina:      "1e192f37c90cf6fcae84119e0e356fa84435274d3bda3fee85b9d24a8f3bf1cd"
    sha256 cellar: :any_skip_relocation, mojave:        "1e192f37c90cf6fcae84119e0e356fa84435274d3bda3fee85b9d24a8f3bf1cd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
        "name": "example",
        "version": "#{version}",
        "description": "A basic apiDoc example"
      }
    EOS
    system bin/"apidoc", "-o", "out"
    api_data_json = (testpath/"out/api_data.json").read
    api_data = JSON.parse api_data_json
    assert_equal api_data.first["version"], version
  end
end
