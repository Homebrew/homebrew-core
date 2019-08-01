require "language/node"

class ApolloCli < Formula
  desc "Tooling for development and production Apollo workflows"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.17.3.tgz"
  sha256 "1fd8c82904e3b70a7133ce30f29545e707468809c6b2cef477836ef1afcd2d2c"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apollo --version")
    assert_match /apollo/, shell_output("#{bin}/apollo help")
  end
end
