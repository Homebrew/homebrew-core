require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.26.0.tgz"
  sha256 "a23097b1d1507b51c3a1f8eb461368520df22fa51390210ca1e7f0055aa0842f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cebc4358240c0fb77d6b5e0feedcdc72640044d50cda92e20130fe959628382" => :catalina
    sha256 "6c6f63f77997ff890b5806ec174867580d582266cd04d279e9251117cf153255" => :mojave
    sha256 "2843a87b865e7af51255448e9acd1f0c3e82b89fb252c1adb2f5cbfcbad826c4" => :high_sierra
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
