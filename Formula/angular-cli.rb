require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.0.5.tgz"
  sha256 "408b92f5184ac7215e582ec5e05e5151cc991b34788343ec63158a67685c693c"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cd0da6ffbc02b2f7b35aa6328ec3f1bbbbc00725bbe12d5ce98845f41d3588b6" => :big_sur
    sha256 "5134865d9dfd821e2197a97c40d130295c59a47caa4a18125fd1ef54e149db74" => :catalina
    sha256 "ecd0f62311158040ad217e26ef96e3cf7574751e4df2ac7dbf4862aa0e7e9fff" => :mojave
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
