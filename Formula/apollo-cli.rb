require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.28.0.tgz"
  sha256 "2ccb4394535288bb6234be31710cafc3c4f2201dd700c8d1e9daaf7d64bf0e07"

  bottle do
    cellar :any_skip_relocation
    sha256 "df7f863ef58314c22c625e94c67ddac92947c680245cf922877a3ea071688050" => :catalina
    sha256 "4d00f15c2b63333e6eb7f3888d26f20f4932aee6c62df4be170b6aefeb9a8346" => :mojave
    sha256 "33dcd219d3885d9885b9e35ac7ede2aca416cb957fd434f555d6ef2e25cc721b" => :high_sierra
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
