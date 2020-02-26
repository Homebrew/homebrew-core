require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.24.0.tgz"
  sha256 "4bdc83420f84674273fc6fcfd0e12fe9f0e73d4663d665e6684b2c78e1fe8952"

  bottle do
    cellar :any_skip_relocation
    sha256 "71fa57c89c415a6f6b5ff40b75e4c9dc2ec4310cab51fdd79ede606ca6549254" => :catalina
    sha256 "35b07fc523297a0e94e29fa46453e4ece999294f3c1f8f083ebc3864cb62439a" => :mojave
    sha256 "2bf53046cef43c0dcb629260e4e75c471801f5625c39507a7ca15a42e05c2d80" => :high_sierra
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
