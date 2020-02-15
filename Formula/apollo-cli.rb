require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.22.1.tgz"
  sha256 "fc94ddadae2843f5600dbb12b5b900807f2639a21a6dd2f52f8557f528e22e52"

  bottle do
    cellar :any_skip_relocation
    sha256 "dba1d1209d24431375aca9f109a284e601ec3b11402f756965baeba6b2cd734c" => :catalina
    sha256 "bfd217e6a00cdaf8e4c52dbe1a8636f0461fc348b7659127fd443878e858f66b" => :mojave
    sha256 "7e14e9f1dbaae663ae63b61032da2f9091709f70707d7918c6297f4658415bd4" => :high_sierra
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
