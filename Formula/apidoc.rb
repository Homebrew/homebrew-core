require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.28.1.tar.gz"
  sha256 "f4ed7813ce5e365c9457dfa9414c7750328965963cc9f1a9ef66baad66071677"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84a921ef6d8c87754b54c6fa9b9340d9eac4945a5eefa5a3c9d475adb62bf681"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c584dbb14ba991608fa16021e29e120be11b4023a87a15954496d66210891ed"
    sha256 cellar: :any_skip_relocation, catalina:      "9c584dbb14ba991608fa16021e29e120be11b4023a87a15954496d66210891ed"
    sha256 cellar: :any_skip_relocation, mojave:        "9c584dbb14ba991608fa16021e29e120be11b4023a87a15954496d66210891ed"
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
