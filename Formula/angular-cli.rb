require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.7.tgz"
  sha256 "03472675501dce6284f31056d949e2fec54630a550299f071ed44aa9ce8c52ca"

  bottle do
    sha256 "630c547be84a2c0f3be89115fadae2f092ac03a1a1e12895f0364c74f688fc51" => :high_sierra
    sha256 "77b2be4b2f4f62e66aa0a4a028e8b73e4d57682474019534b2218e3c7963beca" => :sierra
    sha256 "dec56704db09f7a37ee2263b4f9b51858be2a38d5523a133d26b3ffd6ae62559" => :el_capitan
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
