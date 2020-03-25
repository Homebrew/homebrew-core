require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.0.tgz"
  sha256 "1c34de7d76f5d92e350ef9bb79b9c16091ddb678cec1ee88f7d0a813a646c32c"

  bottle do
    cellar :any_skip_relocation
    sha256 "182a063ff36b05a76edc67d489f47e4f646150c70a5b11103000d9176658db89" => :catalina
    sha256 "9fd535e7586ba1c8e72883ea36476f18737b35feff93c7530562b99afd85a42b" => :mojave
    sha256 "64c9eb347dc7874708001017046b3baa3935b3e1fde4f06a8ac05affa6c1ce70" => :high_sierra
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
