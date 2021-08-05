require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.0.tgz"
  sha256 "1e6a66259a9b759838f3df4ba5efd0ecee7c7ea98e35f1698bb7681551ac29ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b234cd436a15d92170fc8db3e006d16939746ae6b3bd2705af09891f1a19879"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f9dc62c7c3ae9fe678c54ccebde71973352b8c3be7d3c38545d15bf9815812f"
    sha256 cellar: :any_skip_relocation, catalina:      "8f9dc62c7c3ae9fe678c54ccebde71973352b8c3be7d3c38545d15bf9815812f"
    sha256 cellar: :any_skip_relocation, mojave:        "8f9dc62c7c3ae9fe678c54ccebde71973352b8c3be7d3c38545d15bf9815812f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b234cd436a15d92170fc8db3e006d16939746ae6b3bd2705af09891f1a19879"
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
