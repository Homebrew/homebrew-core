require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.1.tgz"
  sha256 "8aee30fc3b5eaa6cf0afd46b0111ad109ebc91d4234b2af9ba9aa7fad7011ba3"

  bottle do
    cellar :any_skip_relocation
    sha256 "ede8fed7e7c3d2a41171003d1fa25b3a787c2f4f6f3f2140c6fc98f6d1926907" => :catalina
    sha256 "d94c9d2117029882d1985ff2fcf2124762cc802aaafd8d77685229377e9a7caa" => :mojave
    sha256 "b12141cb6497722a1a162e006870f321391784d6b1af23cf90ab250c20bb039c" => :high_sierra
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
