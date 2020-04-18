require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.11.tgz"
  sha256 "a61008e7200773f2c05bebbd769b8e8d899b9c5a2d5fd93a7161561baed002b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a9779b16435d6e0d1fab966be10bafba76055ca2243994cb6fde666ca7ec5b2" => :catalina
    sha256 "806c9f7626d3e0c80d247cb5b690aebbdd860faf0f1a51dd3724ca9b22fd9969" => :mojave
    sha256 "4dd6ac681a2372a3d3da2d79f32f8f7ec830cc43f1df1e4322cfb6111530bf9e" => :high_sierra
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
