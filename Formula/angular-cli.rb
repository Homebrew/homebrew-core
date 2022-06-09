require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.0.1.tgz"
  sha256 "5de1fd1422cd2a47a6ff6eb5d195fea90bfae368cc73921aa1593a4d751557b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1e98ce4ca324abed3572ff165c21ea18863b57f6b2623a1325d1450ac6c8992"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1e98ce4ca324abed3572ff165c21ea18863b57f6b2623a1325d1450ac6c8992"
    sha256 cellar: :any_skip_relocation, monterey:       "ec32e4f11b94c5af0975a9a6d13e66987e824659de25c1b5fee2851f0ade4d2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec32e4f11b94c5af0975a9a6d13e66987e824659de25c1b5fee2851f0ade4d2e"
    sha256 cellar: :any_skip_relocation, catalina:       "ec32e4f11b94c5af0975a9a6d13e66987e824659de25c1b5fee2851f0ade4d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e98ce4ca324abed3572ff165c21ea18863b57f6b2623a1325d1450ac6c8992"
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
