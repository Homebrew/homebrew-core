require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.54.0.tar.gz"
  sha256 "aaa30468ff3ad1b7aaaec133dcd2b4bb7828e950c897195c4c932bbbb024caaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23ed900dca77564f5327968a44cf247ff606bf4206f580520eb18b89f31961fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23ed900dca77564f5327968a44cf247ff606bf4206f580520eb18b89f31961fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23ed900dca77564f5327968a44cf247ff606bf4206f580520eb18b89f31961fc"
    sha256 cellar: :any_skip_relocation, ventura:        "90ee783d93e545d6ee818993037c90d4ca0e17320678a12f27eb631e6521c2a9"
    sha256 cellar: :any_skip_relocation, monterey:       "90ee783d93e545d6ee818993037c90d4ca0e17320678a12f27eb631e6521c2a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "90ee783d93e545d6ee818993037c90d4ca0e17320678a12f27eb631e6521c2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bbd512759bbf7c3415c49ef44089bd6e7cf37db7b1c929dcf1d16853196e740"
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
