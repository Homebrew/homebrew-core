require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.32.11.tgz"
  sha256 "5605644dfe12bec6deedc235698c0d1c2cb505dca6873f19956cb90c78a51197"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f37fc6df9fbab7135ed5b679b49e23916bb89403ce5986e4946c89319a27457e"
    sha256 cellar: :any_skip_relocation, big_sur:       "26887b2daff341f82a7bf08fbb9cc473dca60e42c4edcc4bfb90b6cecc748511"
    sha256 cellar: :any_skip_relocation, catalina:      "26887b2daff341f82a7bf08fbb9cc473dca60e42c4edcc4bfb90b6cecc748511"
    sha256 cellar: :any_skip_relocation, mojave:        "26887b2daff341f82a7bf08fbb9cc473dca60e42c4edcc4bfb90b6cecc748511"
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
    assert_match "Error: No schema provider was created", error_output
  end
end
