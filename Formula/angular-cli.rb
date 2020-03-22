require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.0.7.tgz"
  sha256 "6a76a48d29c48c9431e37eaa9499b960323adc27a31572d8535cdb832047a6c1"

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
