class Graphqurl < Formula
  desc "Curl for GraphQL with autocomplete, subscriptions and GraphiQL"
  homepage "https://github.com/hasura/graphqurl"
  url "https://registry.npmjs.org/graphqurl/-/graphqurl-2.0.0.tgz"
  sha256 "589fd91ec8b40554ff2d32a35846bc9e31466ce9824530ccd3176aafe8e8ce75"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5c7b7760dba8c9c4652d41475697c10e83ea2e22b382e2091c54a9129dff898b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Build an `:all` bottle by removing log file.
    node_modules = libexec/"lib/node_modules/graphqurl/node_modules"
    rm node_modules/"@oclif/linewrap/yarn-error.log"
  end

  test do
    output = Utils.safe_popen_read(bin/"gq", "https://graphqlzero.almansi.me/api",
                                              "--header", "Content-Type: application/json",
                                              "--introspect")
    assert_match "type Query {", output
  end
end
