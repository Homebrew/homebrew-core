require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/1.0.3.tar.gz"
  sha256 "822756eacfd7c12f3221bf8c0b85b8c1d30b8bc714e6f8c7da3de60b219c6d44"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec24bc9e8fe7916aa23a1920d176641a8ccfca7f04b29656d31f09d97465c2a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec24bc9e8fe7916aa23a1920d176641a8ccfca7f04b29656d31f09d97465c2a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec24bc9e8fe7916aa23a1920d176641a8ccfca7f04b29656d31f09d97465c2a1"
    sha256 cellar: :any_skip_relocation, ventura:        "fd4e6b3b17a2bdef549fd578802154f30c306d9af1905212383ae57bd73d70e2"
    sha256 cellar: :any_skip_relocation, monterey:       "fd4e6b3b17a2bdef549fd578802154f30c306d9af1905212383ae57bd73d70e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd4e6b3b17a2bdef549fd578802154f30c306d9af1905212383ae57bd73d70e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3db7d4dbd0ebdab723a5e2b23c991dfdaf7562888965f793162c28959533e65"
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
