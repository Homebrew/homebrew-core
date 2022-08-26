require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.1.tgz"
  sha256 "194b04b4e70abe1d59397629f71fd3838f294a52f1d465bfa107f2ebe063b59a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0acd98ad224e33005ec6c1b8443cf6c06267f868efc92371184bcb21ff09af7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0acd98ad224e33005ec6c1b8443cf6c06267f868efc92371184bcb21ff09af7"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ceb62878355b84a78f8ffe9be54a4a0ac59da554032d1ee95e9ffbc5ddb72a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6ceb62878355b84a78f8ffe9be54a4a0ac59da554032d1ee95e9ffbc5ddb72a"
    sha256 cellar: :any_skip_relocation, catalina:       "c6ceb62878355b84a78f8ffe9be54a4a0ac59da554032d1ee95e9ffbc5ddb72a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0acd98ad224e33005ec6c1b8443cf6c06267f868efc92371184bcb21ff09af7"
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
