require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.1.tgz"
  sha256 "8aee30fc3b5eaa6cf0afd46b0111ad109ebc91d4234b2af9ba9aa7fad7011ba3"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0f35a065156914fd9788b0621956ca6148aea6c967f1d936e1a75c77a6a9ee4" => :catalina
    sha256 "3fe2c00c30457a6be1cdd68f857f1316771118605a9cc174fe8e48470c5dde86" => :mojave
    sha256 "1cefd0447b33c8507d90e9542a4a9c60497d7f42e686b633c84769edb568bb84" => :high_sierra
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
