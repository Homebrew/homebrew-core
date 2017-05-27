require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.0.6.tgz"
  sha256 "8e81804d726652448c954b8450225372ec49a8c4cce47186f1fba952e3a6c0ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1802ade502e23086a0e050e93520304f597c3f0020d1beb4c08ef7d49b89f2c" => :sierra
    sha256 "dec271cd26624aa3792ed264b6e64f0d170ff74a9630827106bcc8b1509d9eeb" => :el_capitan
    sha256 "28f92883c9b76aefbb40ac786ae00dbecfa9bff215dbb08319301f11e8646600" => :yosemite
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
