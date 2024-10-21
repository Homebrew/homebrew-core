class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.9.tgz"
  sha256 "78c8016be46aae5b33f9161565a07cbee41cd927890721b0bb0046e0beb02ea0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eaaa26b49e276c73396c8872313abd3b57dfb881a900e26396d221315d6ba73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eaaa26b49e276c73396c8872313abd3b57dfb881a900e26396d221315d6ba73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0eaaa26b49e276c73396c8872313abd3b57dfb881a900e26396d221315d6ba73"
    sha256 cellar: :any_skip_relocation, sonoma:        "d96c64e45e52cd3629df8c8a0fa7b7dff48ee234de1fa8b04f5db17aaf45c543"
    sha256 cellar: :any_skip_relocation, ventura:       "d96c64e45e52cd3629df8c8a0fa7b7dff48ee234de1fa8b04f5db17aaf45c543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eaaa26b49e276c73396c8872313abd3b57dfb881a900e26396d221315d6ba73"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
