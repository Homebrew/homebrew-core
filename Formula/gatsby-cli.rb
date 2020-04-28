require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.0.tgz"
  sha256 "884f7642130a793cc888768eb3446ac2ab41b41ea61d3e9a07ca221d83c2a417"

  bottle do
    sha256 "917fd331081e573aaaad32b6e0b5f15a2ce78b24463f89018f97cf468b39c3ce" => :catalina
    sha256 "5c628bf1726093a6c137acc3d1f9cd80111edbc9ac39017120790210d392dc91" => :mojave
    sha256 "64b31970d23db662af648e5a3205711e0b64d6e056239f83b7b6bad67fb6cb83" => :high_sierra
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
