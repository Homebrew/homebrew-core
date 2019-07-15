require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.15.tgz"
  sha256 "7eb2d2c117e62adb49e143e3395dde61585095c6fd2326b973ceaab8de47c4ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdf51b1678a594a00e43364716d830092c00b1ff00090b0352e0fdf4ab5852db" => :mojave
    sha256 "72c85eb274b4b7855af5407428f71629509492cead48cf9d686969c7dfe403ca" => :high_sierra
    sha256 "10d23d9d647ecfb7f54aca3c88a237f50965fac7702a53f0209e05538125bd08" => :sierra
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
