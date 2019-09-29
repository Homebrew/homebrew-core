require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.6.tgz"
  sha256 "5091c9468e66f435684f801628334d112ee1d9e1b72203b6acd853aa516e3d3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5ccb0511329af9353296819b031857af3e6440a3d7fefe2f0868e91516f1e0f" => :catalina
    sha256 "0a961136be100e27e46e1d3dc1d38149b093b00e79e778c1693eaf11e123831d" => :mojave
    sha256 "a23e6ca3fe76860c0578920b52ad2f6763f384a02f8b3090121285a4f5adb77b" => :high_sierra
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
