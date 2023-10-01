require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.3.tgz"
  sha256 "fbfe158f116b0f7cd319140f68a2229d1639ccb30323e3bb6162b742918da681"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c315c1c934c1e36a09e915398d4b8d095db5d42753c6bfc729d1d3511671c4e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "daf05ad6973f0a7aced7e115541aaa458f024ee22198c9cc8eef8a3ea9790408"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daf05ad6973f0a7aced7e115541aaa458f024ee22198c9cc8eef8a3ea9790408"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daf05ad6973f0a7aced7e115541aaa458f024ee22198c9cc8eef8a3ea9790408"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b71b67a1ce6f8bde1499a771588485c39386d934a661966c5b3bd01fe2be5e5"
    sha256 cellar: :any_skip_relocation, ventura:        "0625ab0d875c5ed10efc8daef180d71bd036ab4ce1e1dd02601dfbb2538d99bf"
    sha256 cellar: :any_skip_relocation, monterey:       "0625ab0d875c5ed10efc8daef180d71bd036ab4ce1e1dd02601dfbb2538d99bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0625ab0d875c5ed10efc8daef180d71bd036ab4ce1e1dd02601dfbb2538d99bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf05ad6973f0a7aced7e115541aaa458f024ee22198c9cc8eef8a3ea9790408"
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
