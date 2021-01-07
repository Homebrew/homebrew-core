require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.0.6.tgz"
  sha256 "ba9ef79db0ea510b17de0a7cd77c31f6971b6832da94d81f4102184988594755"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ed6667169e0c3e1632c79386fb0739455014ac888ebe0db7854550053be0c06d" => :big_sur
    sha256 "7f88ad777b8824e43eaa3def6b80ffae6a07a03c24ce192d8bb7ed5d04a6983a" => :arm64_big_sur
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
