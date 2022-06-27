class ApolloIosCli < Formula
  desc "Generate Swift code for your GraphQL client"
  homepage "https://github.com/apollographql/apollo-ios/tree/release/1.0/CodegenCLI"
  url "https://github.com/apollographql/apollo-ios/releases/download/1.0.0-alpha.8/apollo-ios-cli_source.tar.gz"
  sha256 "16b14b6f032f0e2d4b9a2a41fe53bbea1a08f414a66c486346f7788ff61eb43e"
  license "MIT"

  depends_on xcode: ["13.3", :build, :test]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/apollo-ios-cli"
  end

  test do
    assert_match "New configuration output to ./apollo-codegen-config.json.",
      shell_output("#{bin}/apollo-ios-cli init").strip

    assert_predicate testpath/"apollo-codegen-config.json", :exist?
    (testpath/"schema.graphqls").write ""

    assert_match "The configuration is valid.",
      shell_output("#{bin}/apollo-ios-cli validate").strip
  end
end
