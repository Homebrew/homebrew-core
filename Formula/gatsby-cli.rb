require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.15.tgz"
  sha256 "3a67324ecf88ab1b244442b54f16c4f8b2de2e4b49f1859bb4ce27e3cb7ee421"

  bottle do
    cellar :any_skip_relocation
    sha256 "44259be85193c7ff310ea567c368e5053a80606a96853f8f1a7e34c08e75286e" => :catalina
    sha256 "5b5596821da657ed00a1865a2803318e6e8adfa8a8bd631edad0b8b105cff822" => :mojave
    sha256 "07d305be827c3d7bbe3e2cd08cd45b0a64cf5e492b42d4934913d0f1a5a388f5" => :high_sierra
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
