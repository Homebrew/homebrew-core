class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.9.tgz"
  sha256 "a64595255fb5d53eeec1b7111457dd4059470ffe81a9bee087968306e65b41ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10f3c0cdc86f258e2e12c3aa9bc6591d111e733a2728862b34a672525e12dbec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10f3c0cdc86f258e2e12c3aa9bc6591d111e733a2728862b34a672525e12dbec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10f3c0cdc86f258e2e12c3aa9bc6591d111e733a2728862b34a672525e12dbec"
    sha256 cellar: :any_skip_relocation, sonoma:        "be3619217a611a8fb5e04d240f6dd581ff0416cde42c8082657e283f4b3d7cef"
    sha256 cellar: :any_skip_relocation, ventura:       "be3619217a611a8fb5e04d240f6dd581ff0416cde42c8082657e283f4b3d7cef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10f3c0cdc86f258e2e12c3aa9bc6591d111e733a2728862b34a672525e12dbec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10f3c0cdc86f258e2e12c3aa9bc6591d111e733a2728862b34a672525e12dbec"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
