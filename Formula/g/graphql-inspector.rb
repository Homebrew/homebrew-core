class GraphqlInspector < Formula
  desc "Validate schema, get schema change notifications, validate operations, and more"
  homepage "https://the-guild.dev/graphql/inspector"
  url "https://registry.npmjs.org/@graphql-inspector/cli/-/cli-7.0.10.tgz"
  sha256 "24a94675671c25c0618797669f9d11551917c542b5364986f4d9711c1fe134a3"
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
