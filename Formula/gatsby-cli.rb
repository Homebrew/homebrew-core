require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.26.tgz"
  sha256 "74ed325c9189184e65019fdf195347c7191e113559558ae9c7ea09e3f64d2355"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d53afdb5d6b6685c9290fa48fcf7bf17189117c2b19593a1bd16d7eeb6a2904" => :mojave
    sha256 "8dc49c4379603ef6aef0cc8c0df3642ff2c068b6568b063705c51e379ba7da58" => :high_sierra
    sha256 "99ba016ddcf79cb32e66da61fbfa60a8c1ded1f95e109fa3ff96c2b20ca3bb97" => :sierra
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
