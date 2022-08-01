require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.52.0.tar.gz"
  sha256 "e78ab86bfbaf1a91386a9ac197f8912357b03cea4d9a296b46ff618f0c20dff6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d356018c90d6077128ee94005504e0a2ec1f30a916c4831d8754d16b34e71b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d356018c90d6077128ee94005504e0a2ec1f30a916c4831d8754d16b34e71b6"
    sha256 cellar: :any_skip_relocation, monterey:       "6a27d70d89e4ba41f4e07565b561b80cae8524562ed05a35577817ce31ded4e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a27d70d89e4ba41f4e07565b561b80cae8524562ed05a35577817ce31ded4e0"
    sha256 cellar: :any_skip_relocation, catalina:       "6a27d70d89e4ba41f4e07565b561b80cae8524562ed05a35577817ce31ded4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bf3ad951c38fc9e40c4908579293fea187094222c1ac7dd94b48972b9896820"
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
