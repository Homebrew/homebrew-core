require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.28.3.tgz"
  sha256 "648334e38f9b8d45ceb59e216b5352d8edd60301b81d035084f823480b7136a7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "73000a5bd181568ffe0c979d8800c6048fe611954c3b68a68034037aee39689a" => :catalina
    sha256 "a8e3edf77278ae0c757dfcef93e5ce337add91954f89ed73256c91f5c28c8e8d" => :mojave
    sha256 "b1ec91bec2690160acdd33b5ba70922ced9d087c99039344038eda1a1f7386d9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "apollo/#{version}", shell_output("#{bin}/apollo --version")

    assert_match "Missing required flag:", shell_output("#{bin}/apollo codegen:generate 2>&1", 2)

    error_output = shell_output("#{bin}/apollo codegen:generate --target typescript 2>&1", 2)
    assert_match "Please add either a client or service config", error_output
  end
end
