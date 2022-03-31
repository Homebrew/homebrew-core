require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.1.tgz"
  sha256 "98cca5d8aa40addedb055173ac5865f9c2579d7abe5b67c7637e5702a31fdf4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b20f18a667566fbc206a06922db0f8832d7c228592a50cb982d8968ff03b2b6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b20f18a667566fbc206a06922db0f8832d7c228592a50cb982d8968ff03b2b6f"
    sha256 cellar: :any_skip_relocation, monterey:       "8dd9d712486b9b4593b57c5f46ab3353cae4b4bba6d87a1dfda16585704101da"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dd9d712486b9b4593b57c5f46ab3353cae4b4bba6d87a1dfda16585704101da"
    sha256 cellar: :any_skip_relocation, catalina:       "8dd9d712486b9b4593b57c5f46ab3353cae4b4bba6d87a1dfda16585704101da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20f18a667566fbc206a06922db0f8832d7c228592a50cb982d8968ff03b2b6f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
