require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.29.tgz"
  sha256 "d13c33580f8acad2622387aa5a6b22ec825dab30b215c8eb8bc8f7b15894a3cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "47f185d74b1f8c067cae92f57fb281638c64d4a5c9b4544e85074769af212c4e" => :mojave
    sha256 "9bbf881e1896dfb68cb4dad35a383e7f3c9f5cc96c447e29bac5f399289f11d0" => :high_sierra
    sha256 "40c85117ea5642f8b961b0f3a2418d3b9e89ef80db25fcea4a67502f69056a26" => :sierra
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
