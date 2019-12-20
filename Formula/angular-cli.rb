require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.21.tgz"
  sha256 "7d6c7ff55042d8911043085dd45c83339bfb1bd28db0e2e452da74a517ba356d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c9a57bec4d90681cf72074c2ab35812feb81f460cd99d69c851acde716dee67" => :catalina
    sha256 "c52ce3e0ff93bc048398ed005fc1cbbb584005db0dea9b2b6ba1703eafaf1a1e" => :mojave
    sha256 "571a8f2032d98c22e9f113a02e74e3b9130872ca0e0e974961db48579ecb74d0" => :high_sierra
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
