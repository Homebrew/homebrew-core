class GraphqlInspector < Formula
  desc "Validate schema, get schema change notifications, validate operations, and more"
  homepage "https://the-guild.dev/graphql/inspector"
  url "https://registry.npmjs.org/@graphql-inspector/cli/-/cli-7.0.10.tgz"
  sha256 "24a94675671c25c0618797669f9d11551917c542b5364986f4d9711c1fe134a3"
  license "MIT"

  bottle do
    manifest_sha256 "7a62056c05b64f7b95a41e3c848b5783533001e022e94aa7fb9894b3d63d56c8"
    sha256 cellar: :any_skip_relocation, all: "055b5a511a36de33515fb1f296bff5b24e41c621a3f08c27f870798f8f01aa37"
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
