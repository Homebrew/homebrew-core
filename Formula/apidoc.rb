require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.26.0.tar.gz"
  sha256 "96c9722fe2ad6044eb93031f4012b08db9f87810aff2f43e22e91c725f1746f6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a21c5e41aad85415f9203b521ffe4602aca269e6394798c1a350daeba409931b" => :big_sur
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
