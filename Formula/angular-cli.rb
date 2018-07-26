require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.1.0.tgz"
  sha256 "2fc68f845bb2c28a914444f6ffc086076d07cc9abfcab656432170c2a2a1232c"

  bottle do
    sha256 "4fc7f40c4c95cdcec7211cea1bb5a58a0918b4d5b636a6fa8d9b0b757b11f5ce" => :high_sierra
    sha256 "d9028214dd4ea44d3b4a3354d5535e1bee38a342b75bba630217c47394a7c89a" => :sierra
    sha256 "3831174aaf9b7a93960e7954fa30e6dae4fbed2a78999ccf5c65a0520b387a41" => :el_capitan
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
