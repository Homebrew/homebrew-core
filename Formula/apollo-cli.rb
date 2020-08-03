require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.30.2.tgz"
  sha256 "4b2ad42823f5da95c021757149bfae471077c701ec0a5f0c9a23f5140c0b4fc6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "98a8eda5bf6c2624b1bbb44a98cb777f33e179f100cc2e055c7e846ffa3cdccc" => :catalina
    sha256 "dfac4f88b790e25a3c0b3e9b58bc7c1779cc415d1ce61de3988ba81506f02634" => :mojave
    sha256 "7a35bdc1f50be5dbd394e964509a3f0c3b902ef1ea514dc5373dc6157ff34268" => :high_sierra
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
