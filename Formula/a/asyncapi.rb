require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.10.0.tgz"
  sha256 "43a7f06d5db58612bedef8d1296f506e06c0b980836c3081a302e90a07ea4e8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b9cf3984cb3679e29c022de2c7cda4a295d1ebac3035239dc462fb8e41db365"
    sha256 cellar: :any,                 arm64_ventura:  "4b9cf3984cb3679e29c022de2c7cda4a295d1ebac3035239dc462fb8e41db365"
    sha256 cellar: :any,                 arm64_monterey: "4b9cf3984cb3679e29c022de2c7cda4a295d1ebac3035239dc462fb8e41db365"
    sha256 cellar: :any,                 sonoma:         "11dec8438fb46da673d4c117f809061253f54a02dc6c30f5c0c313d713ac2b73"
    sha256 cellar: :any,                 ventura:        "11dec8438fb46da673d4c117f809061253f54a02dc6c30f5c0c313d713ac2b73"
    sha256 cellar: :any,                 monterey:       "11dec8438fb46da673d4c117f809061253f54a02dc6c30f5c0c313d713ac2b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1d6948fc4a90072923847762d1ce336231c90d2704ccb30178a3fdc52fad650"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
