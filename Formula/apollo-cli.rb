require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.32.0.tgz"
  sha256 "03aa5537731ebb1f8add2533973c254ae6da0d584d9e794dd513e8f42d454454"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "763b7d1f2009f4a0400cbeea4e721ac34bbd9ed92cbbe25956eaba4f7c6907c8" => :big_sur
    sha256 "5c5854263b540dd7b26fc8029a6d9e1c73f4816d08aefa0b07ab227c3288c1eb" => :catalina
    sha256 "217e217336d8512d21aeb8b3ccc5e4b994c237af663d03a4c08ff1684afff3be" => :mojave
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
