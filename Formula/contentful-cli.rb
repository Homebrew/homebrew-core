require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-0.36.1.tgz"
  sha256 "96bf2ac01eb7c4aa85f0fc1a0fa0fdce49409ffb99a52827c1268d3bb92b089e"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "793a87335c5cd8b73687c8830cf9db531e82d2026cf98cf5f7c9b1d11834d009" => :mojave
    sha256 "940a24afcffd1d0531de0e3286129415221b7a91823d3490967c5456a9da31b2" => :high_sierra
    sha256 "4231bd6d12e6a5e9aebd0e1bee6e6c4f1b7d655359cce7ded0315158dc1b50ae" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
