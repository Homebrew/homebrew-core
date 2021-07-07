require "language/node"

class Graphqurl < Formula
  desc "Curl for GraphQL with autocomplete, subscriptions and GraphiQL"
  homepage "https://github.com/hasura/graphqurl"
  url "https://registry.npmjs.org/graphqurl/-/graphqurl-1.0.1.tgz"
  sha256 "c6dfb4106d5b8b0860c0df5dffd0cc75095d280ad4841bda25a6ef0b9a75e199"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = Utils.safe_popen_read(bin/"gq", "https://graphqlzero.almansi.me/api", "--introspect")
    assert_match "directive @cacheControl(maxAge: Int, scope: CacheControlScope)", output
  end
end
