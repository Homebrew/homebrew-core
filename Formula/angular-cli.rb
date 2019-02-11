require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.3.1.tgz"
  sha256 "e92e81c124de14990c714c171ab91e2dd3d35824ca642ebc1cb0601da49a738f"

  bottle do
    sha256 "3552622b25f4141f5ae0bde26c76e19f5daabf538c7cde64916ac85c074f268d" => :mojave
    sha256 "7dfd16495360feb34280fdc233e881c67fb05cb26ffc04092ba821d7a532ac1e" => :high_sierra
    sha256 "b57b030ab0da3cc446390ae8bcc0102ae87c3fd5ee4379037675d528b75f7f7f" => :sierra
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
