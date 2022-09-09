require "language/node"

class Mailsy < Formula
  desc "quickly generate a temporary email address"
  homepage "https://github.com/BalliAsghar/Mailsy#readme"
  url "https://registry.npmjs.org/mailsy/-/mailsy-3.0.4.tgz"
  sha256 "0895bf590d3844f03d50f4d6eea4d982a562c7f9d4b921943bf6a02286ddac1f"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mailsy v")
  end
end
