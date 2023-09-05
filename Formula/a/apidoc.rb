require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/1.2.0.tar.gz"
  sha256 "45812a66432ec3d7dc97e557bab0a9f9a877f0616a95c2c49979b67ba8cfb0cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ae177f380e815fcea0ae8cf238d1cba13f50e7d78195e0329c6574155a53624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ae177f380e815fcea0ae8cf238d1cba13f50e7d78195e0329c6574155a53624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ae177f380e815fcea0ae8cf238d1cba13f50e7d78195e0329c6574155a53624"
    sha256 cellar: :any_skip_relocation, ventura:        "3f913c5b951f97de85b776b9d08f7a53f1be7d83dca04f2e210ecb9343f94866"
    sha256 cellar: :any_skip_relocation, monterey:       "3f913c5b951f97de85b776b9d08f7a53f1be7d83dca04f2e210ecb9343f94866"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f913c5b951f97de85b776b9d08f7a53f1be7d83dca04f2e210ecb9343f94866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "814be573ff5193c0e23d6ffffe1fee94fd5d9ed5efbc4684bf3e39ac0325d34f"
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
