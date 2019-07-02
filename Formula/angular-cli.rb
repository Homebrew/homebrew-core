require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.1.0.tgz"
  sha256 "cc9bbc9c9a56be53bb062862a340f3d7c99d425f5e085dbb928bb961d0673116"

  bottle do
    cellar :any_skip_relocation
    sha256 "652458aa6384cd8504daa15b7db4eae9e879f273654b73e3ef745bd3f6d3c265" => :mojave
    sha256 "bf1a4f0c1c7e1ee5caf1659a9c06a88a186b351dafe6cbbe54f129aad74d5bf1" => :high_sierra
    sha256 "c67dc57baf2f6d039cf04de90a83af93fac81c88894a4a7bf890b319c0b89132" => :sierra
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
