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
    sha256 "ed6667169e0c3e1632c79386fb0739455014ac888ebe0db7854550053be0c06d" => :big_sur
    sha256 "ad65348d068a53cbc6dd55215652ac83699c2bb7ad527d09232bada8e098a8bc" => :catalina
    sha256 "955a0a841f85d38e9a2eac0d6f955c8ed3cf52ff8571aeda2cb747920be05d42" => :mojave
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
