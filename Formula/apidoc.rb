require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.50.1.tar.gz"
  sha256 "23af169410f5e25414b444d85f346f304ce2e494fe2c3c034cdf256e02e22218"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98d026c39e2734a6efadad3105e6007a1bef42c36d3f3ab10466cd6ad5a27df8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d5a43ec7bf060ebd82429bbb9653f8450ebaaed5a31aaec0c3c9ccec57e65cd"
    sha256 cellar: :any_skip_relocation, monterey:       "3d30068d8e095bb6fd05505a69cdfe6272e032ad157dc07e304195317ea24664"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d30068d8e095bb6fd05505a69cdfe6272e032ad157dc07e304195317ea24664"
    sha256 cellar: :any_skip_relocation, catalina:       "3d30068d8e095bb6fd05505a69cdfe6272e032ad157dc07e304195317ea24664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33af4cb13226ef09da336332ae043fbf3628df1fbc740b3f0e87fd53b08d4039"
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
