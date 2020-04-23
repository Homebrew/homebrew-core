require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.27.3.tgz"
  sha256 "77959a3f8d388ee8ba7428314c52674bb63e641abbfb2a38806dca6d1086776b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3308b4f23353a8e02dfd4b71348f32c7abe0a96104f56d524956fafb33b17a5b" => :catalina
    sha256 "0c175579350f6b0a9846062d75e7e2c4d4e24485f45d061156281002afc46877" => :mojave
    sha256 "5bd36a99e0dc384ba786435d65a4d694c13651d9183e5922ae309952aaf4d598" => :high_sierra
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
