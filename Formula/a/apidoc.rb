class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/refs/tags/1.2.0.tar.gz"
  sha256 "45812a66432ec3d7dc97e557bab0a9f9a877f0616a95c2c49979b67ba8cfb0cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "77eead90a2e275963902897bb539d05529082eefc6da4862e006cce26e850fb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e50dd2df96beabbbb2ae46b9066c60903b6c778798fa172aeece50e8a68d78b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ae177f380e815fcea0ae8cf238d1cba13f50e7d78195e0329c6574155a53624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ae177f380e815fcea0ae8cf238d1cba13f50e7d78195e0329c6574155a53624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ae177f380e815fcea0ae8cf238d1cba13f50e7d78195e0329c6574155a53624"
    sha256 cellar: :any_skip_relocation, sonoma:         "9650b7a10fbcb0995dd5e7e4d389360f5f8904a5f8773cb67cd683ebe8b7df15"
    sha256 cellar: :any_skip_relocation, ventura:        "3f913c5b951f97de85b776b9d08f7a53f1be7d83dca04f2e210ecb9343f94866"
    sha256 cellar: :any_skip_relocation, monterey:       "3f913c5b951f97de85b776b9d08f7a53f1be7d83dca04f2e210ecb9343f94866"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f913c5b951f97de85b776b9d08f7a53f1be7d83dca04f2e210ecb9343f94866"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f49ecbead9febb009893cce39dd1956a463b7b7ad419fefb783f78705e57f8f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "814be573ff5193c0e23d6ffffe1fee94fd5d9ed5efbc4684bf3e39ac0325d34f"
  end

  deprecate! date: "2024-07-16", because: :repo_archived
  disable! date: "2025-07-17", because: :repo_archived

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"api.go").write <<~GO
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
    GO
    (testpath/"apidoc.json").write <<~JSON
      {
        "name": "brew test example",
        "version": "#{version}",
        "description": "A basic apiDoc example"
      }
    JSON
    system bin/"apidoc", "-i", ".", "-o", "out"
    assert_path_exists testpath/"out/assets/main.bundle.js"
  end
end
