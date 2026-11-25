class GraphqlInspector < Formula
  desc "Validate schema, get schema change notifications, validate operations, and more"
  homepage "https://the-guild.dev/graphql/inspector"
  url "https://registry.npmjs.org/@graphql-inspector/cli/-/cli-7.0.9.tgz"
  sha256 "f722e6d29b497b25d323eeabae33325cab985ba2c17fc0f7d560b4012f85b69f"
  license "MIT"

  bottle do
    manifest_sha256 "c84f43f5245ae4e2f3d1ed131aaf80952d6f5cc2f8d8905ebb32018e2e6c4d6b"
    sha256 cellar: :any_skip_relocation, all: "c04317d077f1bd4b07cb3785bb3c5c7ef66fce84dbecd31373cd52e0279db31a"
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
