require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.0.6.tgz"
  sha256 "8e81804d726652448c954b8450225372ec49a8c4cce47186f1fba952e3a6c0ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "127e5ef5620a2dcee789700c2ab776b7bd4cf97b2627eee685e24ef8aa02cf8b" => :sierra
    sha256 "915d1a739c3e7bc3cfc1bd22e11c32798bb94126cee3d483a8fd9055a102118b" => :el_capitan
    sha256 "9faa57bc40d1d3b82003d2754541ca8dcc3c3fd10437f5d98c3dc80007692413" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.1.0-rc.2.tgz"
    version "1.1.0-rc.2"
    sha256 "a025f4abd05665d88d1104a4854bde69921e2e49e8b327c60e52207e8fa64e7e"
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
