class GraphqlInspector < Formula
  desc "Validate schema, get schema change notifications, validate operations, and more"
  homepage "https://the-guild.dev/graphql/inspector"
  url "https://registry.npmjs.org/@graphql-inspector/cli/-/cli-7.0.8.tgz"
  sha256 "6e286fd779e0243849037f01373bd59578708fc521d8983d94eb2a64dfe86936"
  license "MIT"

  bottle do
    manifest_sha256 "b8c85d8d1b3c1f4d795b8fc3748140e6902b8e6f2c1dd61ad173afa3779d20bb"
    sha256 cellar: :any_skip_relocation, all: "b1d74a68a4bffcd36884443d37272aedfdef7dcb9c466e76fa6002abde410efc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"oldSchema.graphql").write <<~GRAPHQL
      type Query {
        hello: String
      }
    GRAPHQL

    (testpath/"newSchema.graphql").write <<~GRAPHQL
      type Query {
        hello: String
        world: String
      }
    GRAPHQL

    diff_output = shell_output("#{bin}/graphql-inspector diff oldSchema.graphql newSchema.graphql")
    assert_match "Field world was added to object type Query", diff_output
    assert_match "No breaking changes detected", diff_output

    system bin/"graphql-inspector", "introspect", "oldSchema.graphql"
    assert_path_exists "graphql.schema.json"
  end
end
