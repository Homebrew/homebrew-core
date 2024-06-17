require "language/node"

class Graphqurl < Formula
  desc "Curl for GraphQL with autocomplete, subscriptions and GraphiQL"
  homepage "https://github.com/hasura/graphqurl"
  url "https://registry.npmjs.org/graphqurl/-/graphqurl-1.0.3.tgz"
  sha256 "77b38dc7f34b7e4f4d3550896a2c4a78ef31a76f202de03b9efaabfc5060ee82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4064bcc041ef4ac42c73311786e16ac5db1d223dc7548e5e29d256ba9dbbe23f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4064bcc041ef4ac42c73311786e16ac5db1d223dc7548e5e29d256ba9dbbe23f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4064bcc041ef4ac42c73311786e16ac5db1d223dc7548e5e29d256ba9dbbe23f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bcd953f3b05d9f84d62ab7f2d90e992cc292608a6c4ce5364a7dcad8a196c97"
    sha256 cellar: :any_skip_relocation, ventura:        "4bcd953f3b05d9f84d62ab7f2d90e992cc292608a6c4ce5364a7dcad8a196c97"
    sha256 cellar: :any_skip_relocation, monterey:       "4bcd953f3b05d9f84d62ab7f2d90e992cc292608a6c4ce5364a7dcad8a196c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4064bcc041ef4ac42c73311786e16ac5db1d223dc7548e5e29d256ba9dbbe23f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = Utils.safe_popen_read(bin/"gq", "https://graphqlzero.almansi.me/api",
                                              "--header", "Content-Type: application/json",
                                              "--introspect")
    assert_match "type Query {", output
  end
end
