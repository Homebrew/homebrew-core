require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.0.tgz"
  sha256 "c02b88cbc1b101c7d0f03caa64679ae9e47575cbef8deab0dac0de74e30bbaf2"

  bottle do
    cellar :any_skip_relocation
    sha256 "01f7d64bfab8dee525c1fedbae30384710890da60fed9bd1c29a32c56debd838" => :mojave
    sha256 "bb7c4e6c341c5c6f673a778550f419bc2e081a6405bf4ac6e72b5f4357d287e7" => :high_sierra
    sha256 "99f7b8913dbb0be54d243bafb91ccdd93c4477160356611d21d66f5a3782c840" => :sierra
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
