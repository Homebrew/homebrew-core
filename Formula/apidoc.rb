require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.53.1.tar.gz"
  sha256 "b9b69588bd11f475190ef57c4b30ba59986b46a5345b8792a2f1ff76d218d1c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "274334eb704290224d7af282ea2b7bbeb9b91e94ce6da3ef803fd9440acb7e98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "274334eb704290224d7af282ea2b7bbeb9b91e94ce6da3ef803fd9440acb7e98"
    sha256 cellar: :any_skip_relocation, monterey:       "ffcb3e06b8873fa7d64ae1b07395d9fdbf24d24c0a03f0dd76440c571ce67600"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffcb3e06b8873fa7d64ae1b07395d9fdbf24d24c0a03f0dd76440c571ce67600"
    sha256 cellar: :any_skip_relocation, catalina:       "ffcb3e06b8873fa7d64ae1b07395d9fdbf24d24c0a03f0dd76440c571ce67600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "323628a8c237a9f56391a898977a9c2b0fa47c4830ababef95b9cb2fe9267786"
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
