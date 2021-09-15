require "language/node"

class Graphqurl < Formula
  desc "Curl for GraphQL with autocomplete, subscriptions and GraphiQL"
  homepage "https://github.com/hasura/graphqurl"
  url "https://registry.npmjs.org/graphqurl/-/graphqurl-1.0.1.tgz"
  sha256 "c6dfb4106d5b8b0860c0df5dffd0cc75095d280ad4841bda25a6ef0b9a75e199"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "138b68d4fffc64cd4ce86e07b618ccfa561aa15a700e8c08c66b20b65797ba70"
    sha256 cellar: :any_skip_relocation, big_sur:       "5300156ac1794e98e8e9e8f261f469ae7a6749631dfd55c8374054f425e83cb4"
    sha256 cellar: :any_skip_relocation, catalina:      "5300156ac1794e98e8e9e8f261f469ae7a6749631dfd55c8374054f425e83cb4"
    sha256 cellar: :any_skip_relocation, mojave:        "5300156ac1794e98e8e9e8f261f469ae7a6749631dfd55c8374054f425e83cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0c19d5f82887b811d0b9f5cdaad5efcfb8da33e970c253af8af63faae597f02"
  end

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
