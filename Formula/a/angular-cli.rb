require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.6.tgz"
  sha256 "45504297c24249e14398c6185412b4b36df9addd4dcb5680e9c15f17e83f9345"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cfc157e1ce58741f0fab9082d695cc792a45be002c96ef4a62b8b1bd55c9429"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cfc157e1ce58741f0fab9082d695cc792a45be002c96ef4a62b8b1bd55c9429"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cfc157e1ce58741f0fab9082d695cc792a45be002c96ef4a62b8b1bd55c9429"
    sha256 cellar: :any_skip_relocation, sonoma:         "662dbe8f6c2be1e7a5b20ef405269353a85e6c239588b185ce5b678f3cf454d2"
    sha256 cellar: :any_skip_relocation, ventura:        "662dbe8f6c2be1e7a5b20ef405269353a85e6c239588b185ce5b678f3cf454d2"
    sha256 cellar: :any_skip_relocation, monterey:       "662dbe8f6c2be1e7a5b20ef405269353a85e6c239588b185ce5b678f3cf454d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cfc157e1ce58741f0fab9082d695cc792a45be002c96ef4a62b8b1bd55c9429"
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
