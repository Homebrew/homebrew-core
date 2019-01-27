require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.2.3.tgz"
  sha256 "03c1a481247f37d2173a9c607dcd1572d02dda31c90198329e8397836a1c09d1"

  bottle do
    sha256 "5dc86b9f46c0923f3d5789ebf4ee6167fdc45d6388800c37fe634c3dbac247f0" => :mojave
    sha256 "7901dbfc56760ab3c0253a85ce55be10f3bce4d9cce0bccf547631a3c8697bb0" => :high_sierra
    sha256 "d2781d5efac84a7dc98380e5186b5496a989de7020773ff99c2ad62ebc7ad23d" => :sierra
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
