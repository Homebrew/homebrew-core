require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.1.0.tgz"
  sha256 "5df88cf1f3452c68caeb85c7f3283b366fab059f1d522dd3414cd498a92a3c97"

  bottle do
    cellar :any_skip_relocation
    sha256 "127e5ef5620a2dcee789700c2ab776b7bd4cf97b2627eee685e24ef8aa02cf8b" => :sierra
    sha256 "915d1a739c3e7bc3cfc1bd22e11c32798bb94126cee3d483a8fd9055a102118b" => :el_capitan
    sha256 "9faa57bc40d1d3b82003d2754541ca8dcc3c3fd10437f5d98c3dc80007692413" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.0-beta.0.tgz"
    version "1.2.0-beta.0"
    sha256 "392898113077fdc5bf2dbd3591b54bc371dee870a1d343fee2d6ccddf2677f6d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert File.exist?("angular-homebrew-test/package.json"), "Project was not created"
  end
end
