require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.51.1.tar.gz"
  sha256 "f2fe6bea7a43bc23936f7b15088fc1f33fa0728a46341bfaebea14096014ed7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b74ba0c32abafffc3071d870c28afb905e98a5469dca9b28c97ea31ef4c52973"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b74ba0c32abafffc3071d870c28afb905e98a5469dca9b28c97ea31ef4c52973"
    sha256 cellar: :any_skip_relocation, monterey:       "af4956028141ee14b32ab71020a659cddfc1fd15d9d0d4199761d111f9a50817"
    sha256 cellar: :any_skip_relocation, big_sur:        "af4956028141ee14b32ab71020a659cddfc1fd15d9d0d4199761d111f9a50817"
    sha256 cellar: :any_skip_relocation, catalina:       "af4956028141ee14b32ab71020a659cddfc1fd15d9d0d4199761d111f9a50817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75039cedddf3ba8c7a056dcb1c5bc539628ac8b0b6d9ac9cc14e845f312dea9d"
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
