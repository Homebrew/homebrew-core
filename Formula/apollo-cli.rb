require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.25.0.tgz"
  sha256 "d59b61403a61f852fb83037bdd3efad20c2a89db1b3af6d0b1ac7975e096abef"

  bottle do
    cellar :any_skip_relocation
    sha256 "c278b362b573caab2ff35fd05f0d312cfc0e3fd219d0b6290560a3f1e1590171" => :catalina
    sha256 "17dd6cb50ea1607ec6414f9a4accf4139cce5c027ba798d73273544a87cbb567" => :mojave
    sha256 "e649d9fc7248f3bb125b5d0ff1aab3a56752b1954b8d5c0ead6c17bd6e884157" => :high_sierra
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
