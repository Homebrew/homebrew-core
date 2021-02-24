require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.32.5.tgz"
  sha256 "f228c76f247c095acbadb848e49764dbe071cd8dbe26c7ed3d29aa5f2685a2f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6bb11bfe26330984742416439f48645192e43c8bcb9fc93bbfadbb01e54c2ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "b532e12c1f1b2ce967e2521977037d5b1bdb079f08a74e40ca9d2141ab2039bd"
    sha256 cellar: :any_skip_relocation, catalina:      "0c724255b43eca654790c28cbfba1cdfc866c2acaa9d8ac6649747750e1e4134"
    sha256 cellar: :any_skip_relocation, mojave:        "4cde2ec9e9efb8a8c1a98aa516ecc93be7af03e3f475fbbcbe867b6eaa90a48e"
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
