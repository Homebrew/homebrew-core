require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.0.tgz"
  sha256 "daa2190d483061ad6e3bdd83c404f6ded08743525a99179b82934a3306e9d4f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "227ed0f25d7eede3553e3a9989758b60f2cea94b97edadb7fa4a22ae5dd624e1" => :catalina
    sha256 "6e7284d3750a7290cb914524d7e639df3444461317d037470be2ece84e03c19d" => :mojave
    sha256 "009893623bc2c978f64500b75a414b4704cd5d3ac223613e118f582e22952a43" => :high_sierra
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
