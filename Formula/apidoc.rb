require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.51.0.tar.gz"
  sha256 "78a8efeb6914af55b5b9e1aa292607aaad33aa9d28cb7855213966f25117fd9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad4ff672bb05d5c11410d631aaaef50df70eed2cc995051ba29da333d0832b4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad4ff672bb05d5c11410d631aaaef50df70eed2cc995051ba29da333d0832b4a"
    sha256 cellar: :any_skip_relocation, monterey:       "20756889c640393b2a8018855482232ca0cb881113979e61b8933395fb470c0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "20756889c640393b2a8018855482232ca0cb881113979e61b8933395fb470c0b"
    sha256 cellar: :any_skip_relocation, catalina:       "20756889c640393b2a8018855482232ca0cb881113979e61b8933395fb470c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec2f7f17ea7d48f4045887cd4399ba7dd7e721b375f6d02408d6c1f1cb91b54"
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
