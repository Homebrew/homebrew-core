require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.33.3.tgz"
  sha256 "c5f5c7ac4cb4d7ed327eda8c6d7a2e8ab24782daaaec4487cb493dd588964781"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb23e8bbac3122c952aa214af6b560481952eaf3f6658069ee6c324966a47d92"
    sha256 cellar: :any_skip_relocation, big_sur:       "664b304b04ddcd9413d42515144e75f1361ecf8c916f96835cc17665a3fa0248"
    sha256 cellar: :any_skip_relocation, catalina:      "664b304b04ddcd9413d42515144e75f1361ecf8c916f96835cc17665a3fa0248"
    sha256 cellar: :any_skip_relocation, mojave:        "664b304b04ddcd9413d42515144e75f1361ecf8c916f96835cc17665a3fa0248"
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
