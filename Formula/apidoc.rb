require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.24.0.tar.gz"
  sha256 "b63797091e9ccd0cc2d65129bb38e54957131067e37029ae137d73eb2e3520d6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b320b931cba5d805a88e825d3edc4c049835c8cf5fe4358a7ec2cf3d0eac8140" => :catalina
    sha256 "3cd2c255226284e948ea29323318e67fcd69d55a47a768a178a87ed457100e27" => :mojave
    sha256 "a8cbad5592a1abb70debd5639539f8a7b9d674f9270069fa389d677a07b01754" => :high_sierra
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
