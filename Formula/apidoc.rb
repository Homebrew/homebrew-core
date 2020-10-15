require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.25.0.tar.gz"
  sha256 "1c6b3e9c234d47495a6c45dbbb6ebb2d9d47ae20d3d5e814f637c47a6bba3f6a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c61fa821d8fff7c5a1dc82b9a7e8f1256299cd042054148b69cbbb88e646c7aa" => :catalina
    sha256 "5af452f07506102633a26f2407e56f5f190d8fc0579d2df468c433a0e8e2d5c6" => :mojave
    sha256 "def407d3837157a7cace0286b075f0f3e4df1b069ba4d53e67b769f497385d6a" => :high_sierra
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
