class Graphqurl < Formula
  desc "Curl for GraphQL with autocomplete, subscriptions and GraphiQL"
  homepage "https://github.com/hasura/graphqurl"
  url "https://registry.npmjs.org/graphqurl/-/graphqurl-2.0.0.tgz"
  sha256 "589fd91ec8b40554ff2d32a35846bc9e31466ce9824530ccd3176aafe8e8ce75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9e6defa9ff7f67c8f7ba622d7c98c051457ff93dece2be0d44055de07ad289f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9e6defa9ff7f67c8f7ba622d7c98c051457ff93dece2be0d44055de07ad289f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9e6defa9ff7f67c8f7ba622d7c98c051457ff93dece2be0d44055de07ad289f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bbe446bb7c88a12a0a6b0f89798baf9c94ddc06cbf276279b42b2dfc7faed53"
    sha256 cellar: :any_skip_relocation, ventura:       "1bbe446bb7c88a12a0a6b0f89798baf9c94ddc06cbf276279b42b2dfc7faed53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09d714f7534e00aa17e275e3616593f66e9e59ebb827b20093f1f1b8701d0838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9e6defa9ff7f67c8f7ba622d7c98c051457ff93dece2be0d44055de07ad289f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = Utils.safe_popen_read(bin/"gq", "https://graphqlzero.almansi.me/api",
                                              "--header", "Content-Type: application/json",
                                              "--introspect")
    assert_match "type Query {", output
  end
end
