require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.27.4.tgz"
  sha256 "56bc7c47532c3aca1bb3d0523bd1447b1af9ae0b68693f3745707ebf8f612783"

  bottle do
    cellar :any_skip_relocation
    sha256 "4999014fd1435c9fd8948d85ac6020bc057000a9f5a6fa7f079f12630749b375" => :catalina
    sha256 "546631e5104a6c2cd91d2156e89d06c3dc088cbbdd291d9b7eefc1ab62fe2388" => :mojave
    sha256 "1bbbd213371d29bbb05826ccff6da14effcc659ede0c1435a12cde8d02af0607" => :high_sierra
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
