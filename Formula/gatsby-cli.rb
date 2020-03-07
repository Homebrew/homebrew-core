require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.10.2.tgz"
  sha256 "bfaaca1d8000d5dece9158589d0fe60ee0c02bbd4b4065ca1526360fc7c5bb7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cf7e5fad966b89e19eff12255cd942b06d26f304b1ebacff7f372295a24cf46" => :catalina
    sha256 "13d59e8304ff599660f065691958a243f6087b23c54b4a1cd911fa4b8364e525" => :mojave
    sha256 "f613c387961669512610d6e7d4670e2bd649d5cdfca5ec0e0fbfc77fdfdfb502" => :high_sierra
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
