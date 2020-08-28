require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.30.2.tgz"
  sha256 "4b2ad42823f5da95c021757149bfae471077c701ec0a5f0c9a23f5140c0b4fc6"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bd1ad9765220fb3317eab0f84c667d2f2eb0af11a76ecc8cd776e25839a1e5e8" => :catalina
    sha256 "9c029c2fdb537ed3fc76e0d3b0f6a342d2b1702dee195dd902ccef4fbde373af" => :mojave
    sha256 "9d144b554da26516ed39d170127208091be284cb38725b4637144b6ace50053c" => :high_sierra
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
