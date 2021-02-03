require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.26.0.tar.gz"
  sha256 "96c9722fe2ad6044eb93031f4012b08db9f87810aff2f43e22e91c725f1746f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2088adcc444b5383d4e3b0d515f8a71ea72bce83b904efdebe489b180c17c49e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4b2fb4eba21944b14438865d6e1bc89db807ee3955f73d118ef5e73565c4bda"
    sha256 cellar: :any_skip_relocation, catalina:      "d9de97c18b4429e8fd5178d76fbe5f404f30d8c5718c131704a7c638b87fa3d6"
    sha256 cellar: :any_skip_relocation, mojave:        "c082730573ffff28f99bebb257b270d4864e113f3c9cbcf967a4831c973c1891"
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
