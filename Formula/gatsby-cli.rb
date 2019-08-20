require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.33.tgz"
  sha256 "a6ae227ec6b015e0d4d0b3c6ed466964e12d991b3d6622ee7a1775b30bc3957b"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e65a62759276625586c62213dd6aba87f75cea44b07d745810db2bfd31b4e1b" => :mojave
    sha256 "73bc4d4768ad66431bcb53043ef32217020c9f86473ed155ef55071b949cc6ca" => :high_sierra
    sha256 "48ca784b3207bfffc6595cfeabecf874ad62b8c1034a6a17247536afdf1f984d" => :sierra
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
