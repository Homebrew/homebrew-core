require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.7.4.tgz"
  sha256 "deb044ec8823bfee8f44f8b16ecc4807a79f7eaa5dec1d13a7b25f6cae8b2cd5"

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
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
