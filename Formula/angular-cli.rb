require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.5.3.tgz"
  sha256 "165a66dd904d0842bf91e8576b77d7ee64e07c7e7fc2820df027adc433a2a689"

  bottle do
    sha256 "ddaa1c02ce1abe7ef8c8c1a11296dff3505498dab5fb0c5cd19d642840ce0ae0" => :high_sierra
    sha256 "26a71837f246b7f7dd3461738b39ed184381cee9d9498b664d1b6322c613879a" => :sierra
    sha256 "e4ad2671fce0abccaafe2f1a73450386ae6c3e691086cc05f4663a8c4638334f" => :el_capitan
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
