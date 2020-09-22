require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.31.0.tgz"
  sha256 "563a0ec96e323731d0d75d841da863f955bd8d32c201fa621cb8ea957832f9d9"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8123c73f093ea20c6ac52641e3417f37df7eda88edacad3ba15f6bc8387b8f8f" => :catalina
    sha256 "7dc749bd8b0fb0c85fdb728e0fab73d7afc52f8ea23bfab82500ed0c7ae0094b" => :mojave
    sha256 "d8af3ee1a3818163625c7c5508830cad9dd4f41103220e17ab87fbe95f0772bf" => :high_sierra
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
