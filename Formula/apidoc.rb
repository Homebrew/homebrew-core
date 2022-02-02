require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.50.4.tar.gz"
  sha256 "e8a145743c9a00175a342465abdf944b3da23ee290e273f44861090a40cefe20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "149323530471677b929bb70fc7d760c62609606be4c6ee10c8c577c052a0bb66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "149323530471677b929bb70fc7d760c62609606be4c6ee10c8c577c052a0bb66"
    sha256 cellar: :any_skip_relocation, monterey:       "e48fb70364b32b6833a75ff2d71e70d1fddf00b7789e887b8da695a0b4193d45"
    sha256 cellar: :any_skip_relocation, big_sur:        "e48fb70364b32b6833a75ff2d71e70d1fddf00b7789e887b8da695a0b4193d45"
    sha256 cellar: :any_skip_relocation, catalina:       "e48fb70364b32b6833a75ff2d71e70d1fddf00b7789e887b8da695a0b4193d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15459d200254a5513bc4d9cb9f9656b3ab987e07db7f1f3c54e1c18c6e449fb7"
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
