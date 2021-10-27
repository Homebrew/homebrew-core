require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.11.tgz"
  sha256 "8dad0dcea85aecf5906a74726146a99c77264faa0650ad9bf31306df1e121dd2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e962f3da366cc0286deee067f6cfc940f4069d585caa42521f100e8931eee5d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e962f3da366cc0286deee067f6cfc940f4069d585caa42521f100e8931eee5d4"
    sha256 cellar: :any_skip_relocation, monterey:       "9e286a646754a005aba802ca36b97cb860e2ac0462928ab510fa16ef4bdeff8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e286a646754a005aba802ca36b97cb860e2ac0462928ab510fa16ef4bdeff8d"
    sha256 cellar: :any_skip_relocation, catalina:       "9e286a646754a005aba802ca36b97cb860e2ac0462928ab510fa16ef4bdeff8d"
    sha256 cellar: :any_skip_relocation, mojave:         "9e286a646754a005aba802ca36b97cb860e2ac0462928ab510fa16ef4bdeff8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e962f3da366cc0286deee067f6cfc940f4069d585caa42521f100e8931eee5d4"
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
