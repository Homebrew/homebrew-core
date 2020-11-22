require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.14.0.tgz"
  sha256 "0050adf5035393a5a2e9696826ac450d0e23ea0c95c1ae0cdfff6d720bd47f04"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7ca2c16582e5be2012ec180e028bb64d1f243bda00b9365fd8c0bc58bd2dcd48" => :big_sur
    sha256 "cee719da76366bea9919135865e1085d78ac69b659390ce33a497db21a902222" => :catalina
    sha256 "b268823bf1f22a7afb71734d2db240d319410fd70f57eac8944cc367760ef9f2" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
