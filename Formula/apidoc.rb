require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.50.3.tar.gz"
  sha256 "af4e73e8bf85071d400a00c6d8eb7b007a7df46ac6912485d1af0c125bf1de9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da6be743a5bbc3b9d3dd36fc5e8d12eb390dfe5b9149d15d473c52d5925d9f84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da6be743a5bbc3b9d3dd36fc5e8d12eb390dfe5b9149d15d473c52d5925d9f84"
    sha256 cellar: :any_skip_relocation, monterey:       "5976390df06873c40902586ba3895e0ac2c6536f158ad90785e93947f1454716"
    sha256 cellar: :any_skip_relocation, big_sur:        "5976390df06873c40902586ba3895e0ac2c6536f158ad90785e93947f1454716"
    sha256 cellar: :any_skip_relocation, catalina:       "5976390df06873c40902586ba3895e0ac2c6536f158ad90785e93947f1454716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "014a3a1d49ba7d5a7f4fe3d28ed5b6de592e1428bc5b608ca87c0e44ed842318"
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
