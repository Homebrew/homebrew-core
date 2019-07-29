require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.21.tgz"
  sha256 "8b59ce47cc50dff5453c02a726b4b691d44373351745b546d800ae8f95c83210"

  bottle do
    cellar :any_skip_relocation
    sha256 "69030944b8388ce3ccdf2c1521e3d35d663928c3bbf04a7e903d90bca4d83b70" => :mojave
    sha256 "fd9d32d9c0789e8e096935e82c019956939f39f1e99ac15302a6223322dc6731" => :high_sierra
    sha256 "c2823473a70767a67aaf5ba0f6067f383ed870ee950263023a5b72a1d320421f" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
