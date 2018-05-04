require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.0.0.tgz"
  sha256 "080d3c166c04f1c2dd98b7527d4a8ded79854274570e843fddcdd897eac9586d"

  bottle do
    sha256 "b45c98aa3778d71746f37070a04aa8790e13f8d0c3bd9ba0de7d751962889d40" => :high_sierra
    sha256 "9ebe8ce1757fcb44d731a05c42136c6770321a64e7bb809946740feef26adb44" => :sierra
    sha256 "b8af388f528b186b3b0d65fd2c5afabbdcc2622f5e54b494f4c0cb794d97e6e9" => :el_capitan
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
