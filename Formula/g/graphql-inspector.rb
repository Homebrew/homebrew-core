class GraphqlInspector < Formula
  desc "Validate schema, get schema change notifications, validate operations, and more"
  homepage "https://the-guild.dev/graphql/inspector"
  url "https://registry.npmjs.org/@graphql-inspector/cli/-/cli-5.0.8.tgz"
  sha256 "738d81999b8c2851ce264112d2a773b225794f21aee3c555f9bdb0f78bc79aab"
  license "MIT"
  head "https://github.com/kamilkisiela/graphql-inspector.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd9a9963b98f89373fa2a37db49e9012f9ca0d1a1485ad554038f5d45e7f9125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd9a9963b98f89373fa2a37db49e9012f9ca0d1a1485ad554038f5d45e7f9125"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd9a9963b98f89373fa2a37db49e9012f9ca0d1a1485ad554038f5d45e7f9125"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b3ebcff1fd9ff768e66b7b4edb37995ab3c079ad0e9bf08501965a60f36c6ae"
    sha256 cellar: :any_skip_relocation, ventura:       "5b3ebcff1fd9ff768e66b7b4edb37995ab3c079ad0e9bf08501965a60f36c6ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51c7fdaf0df2146853bb2314f09c4e7086e8f700712d7fd360d009ecfa582ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd9a9963b98f89373fa2a37db49e9012f9ca0d1a1485ad554038f5d45e7f9125"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
