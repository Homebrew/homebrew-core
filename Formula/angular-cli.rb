require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.19.tgz"
  sha256 "c062b52ac2503fea168da198ec184992b7407b1560e8bb17eab3b78689d2db43"

  bottle do
    cellar :any_skip_relocation
    sha256 "11eba9373cb96b8ce903fdc42e3e36291a5dba46f652c3a373e242bee32ef1aa" => :catalina
    sha256 "54d7fddbf220fa8d679b543721a15e1ab1a2a84faa45a4d05c0c2e20523aa331" => :mojave
    sha256 "eb7a7e71c6daae9bb387e6351a9ff185da19accfb60e5867f19d81cc5aaf7b2b" => :high_sierra
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
