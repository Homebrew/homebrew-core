require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.33.1.tgz"
  sha256 "d88d7bfebd0562c2b6bd92d31b9278a2fb059adb150531bc82fa7f92ee07085f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8cd105f20ec57b9da570ac1c34604a3f444b9e6d206244aa0288c65787770385"
    sha256 cellar: :any_skip_relocation, big_sur:       "15e1eb013991a0984d0029e896e672907d9aa029b378774cfb6e62f368aed190"
    sha256 cellar: :any_skip_relocation, catalina:      "15e1eb013991a0984d0029e896e672907d9aa029b378774cfb6e62f368aed190"
    sha256 cellar: :any_skip_relocation, mojave:        "15e1eb013991a0984d0029e896e672907d9aa029b378774cfb6e62f368aed190"
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
