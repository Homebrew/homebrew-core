require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.2.2.tgz"
  sha256 "6021ee904985e7811b5d4daabd777f414f4ead43d38a93f4e2bc4bbb5079567f"

  bottle do
    cellar :any_skip_relocation
    sha256 "00a8ed0603600400ab4994dafdd8b39ad47ae8a7a8cdfab4ee61be2d2d3d1ddf" => :mojave
    sha256 "21552fa7382d61fbc9a362e2a6bfdfd7e9b5c7607cb80c5db0ee0a14e73c5efa" => :high_sierra
    sha256 "43da5d2eb22fb10b725aa861ae416697d44c78740dab0c489df5f5e758ea2879" => :sierra
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
