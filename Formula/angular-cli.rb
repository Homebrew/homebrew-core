require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.0.3.tgz"
  sha256 "72a9516602c95532aab8307e92a838b0691a739df23b89235e774479441e4c05"

  bottle do
    sha256 "c5799a02ab22270ee26fde9e2022c8204980237f87e107ddc1ebba4bb680476c" => :mojave
    sha256 "a9953033c9d291e390d16e692e1e32179d5634f180ebe723a65d295e89afbf2f" => :high_sierra
    sha256 "a321070596296cbbb3dd60354ad4dd757788535948638810875f2b806402b1e3" => :sierra
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
