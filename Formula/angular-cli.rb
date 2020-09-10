require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.1.1.tgz"
  sha256 "63b03d31e9fa2f3cdf804bf07a59f3783e3a90f310d9dcc2b645e6497e5aa5d4"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cfce9bc4181ff4294d3b79c27ca911f538bd3305c358e8a4474f9e0a89ea0708" => :catalina
    sha256 "db9e70a0f9b9e49ece797880a2db34023e9688c2ff3dcbd945acb59fc39cc7f0" => :mojave
    sha256 "f79237471302f693ea2167834f0f4a5976161038c8981b8e6381fd84ef8ca9fa" => :high_sierra
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
