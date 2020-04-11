require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.27.0.tgz"
  sha256 "ec4fc755515a527262cfc1a8c2925b8a3c05a8f81a16bb157e063ce71018fe5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0446d42369a39a9260e281080f96eaf7f13a06f524c38b08fca84e2aadba7733" => :catalina
    sha256 "09c153c7ccaf882593f9bba13c91ee01188efca5d84b7ad797f08db016beb1e0" => :mojave
    sha256 "053d12b2b69be42d49bbd52e6fba1b92448bd62cca4313fc39ba228a1510a100" => :high_sierra
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
