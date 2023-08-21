require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/1.1.0.tar.gz"
  sha256 "2c1b71b6a855906ae7f8cd5db620847b7ee36c2b9a6b163655f7238462d80df8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d0b9cf6899949620b67fc230097694db18eb1d7f8ef8c3b57f3c0f6b9c2177e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d0b9cf6899949620b67fc230097694db18eb1d7f8ef8c3b57f3c0f6b9c2177e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d0b9cf6899949620b67fc230097694db18eb1d7f8ef8c3b57f3c0f6b9c2177e"
    sha256 cellar: :any_skip_relocation, ventura:        "4949695512455c331862f9aa6b60d9e12af35c537bff2566b48735060d8cb570"
    sha256 cellar: :any_skip_relocation, monterey:       "4949695512455c331862f9aa6b60d9e12af35c537bff2566b48735060d8cb570"
    sha256 cellar: :any_skip_relocation, big_sur:        "4949695512455c331862f9aa6b60d9e12af35c537bff2566b48735060d8cb570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b7e6603ec965ae74c4005ebf96fd5bca89d04748af93b3dccab587234830bd8"
  end

  depends_on "node"

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
