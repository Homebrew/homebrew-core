require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.53.1.tar.gz"
  sha256 "b9b69588bd11f475190ef57c4b30ba59986b46a5345b8792a2f1ff76d218d1c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91e59f29872ea0e20129bd1f5e8ee3eb88e181481fe66a858052be7e65d34f50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "806df7048f9663c9b06ad2eca73c51b6ec86475dbac257fd2baa46c9e4105412"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "806df7048f9663c9b06ad2eca73c51b6ec86475dbac257fd2baa46c9e4105412"
    sha256 cellar: :any_skip_relocation, ventura:        "0208d7dbd20f21eb5f0600923e24312528add42602b1645903b07c247d91ef74"
    sha256 cellar: :any_skip_relocation, monterey:       "bb8507b7309e30fc857874614b55751301b22cbd2bbf1c8454605402230ab790"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb8507b7309e30fc857874614b55751301b22cbd2bbf1c8454605402230ab790"
    sha256 cellar: :any_skip_relocation, catalina:       "bb8507b7309e30fc857874614b55751301b22cbd2bbf1c8454605402230ab790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3c01dd9fc2116c20b85a2568900ddd2c13dfc20c08a5bbf36e81c84f1d76443"
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
