require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.3.4.tgz"
  sha256 "96c4f0f9a2741f03a6f405e20241e4d9c15d87d9069287d4897358b3f7e986e6"

  bottle do
    sha256 "98ac98a395ee642744464060b6e5848c32ea4f359569ec0c79bf8fa7958a6ae8" => :mojave
    sha256 "835635769af4209982b7337892d9fe8c8999a049782c4550f074f20c470bbddc" => :high_sierra
    sha256 "55d6501b1b3e16770ede058e77a6f050ca46883c8042bb005d8860280c34e5b9" => :sierra
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
