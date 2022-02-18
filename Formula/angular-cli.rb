require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.2.4.tgz"
  sha256 "53da687323ae5cf721eb89c4b4606577b8233ffc7728d0e561214167b229d40d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc52e7502241ce3f7458876a85f25314d24b3e142161d22d9af568f9fab6089f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc52e7502241ce3f7458876a85f25314d24b3e142161d22d9af568f9fab6089f"
    sha256 cellar: :any_skip_relocation, monterey:       "d56578d0aa53c9ea0f3bcfaa74453851b9a2cbcf35b0a8bf596bc110f7055578"
    sha256 cellar: :any_skip_relocation, big_sur:        "d56578d0aa53c9ea0f3bcfaa74453851b9a2cbcf35b0a8bf596bc110f7055578"
    sha256 cellar: :any_skip_relocation, catalina:       "d56578d0aa53c9ea0f3bcfaa74453851b9a2cbcf35b0a8bf596bc110f7055578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc52e7502241ce3f7458876a85f25314d24b3e142161d22d9af568f9fab6089f"
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
