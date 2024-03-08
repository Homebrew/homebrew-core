require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.1.tgz"
  sha256 "f186f5ecd23ea6b00565c030b3e54361a094b2bc99a8279baad5337f4931f921"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6d67015df3fa67453712e77feaad07d82b5f1879c0c43c7ba17a5370682b96b3"
    sha256 cellar: :any,                 arm64_ventura:  "6d67015df3fa67453712e77feaad07d82b5f1879c0c43c7ba17a5370682b96b3"
    sha256 cellar: :any,                 arm64_monterey: "6d67015df3fa67453712e77feaad07d82b5f1879c0c43c7ba17a5370682b96b3"
    sha256 cellar: :any,                 sonoma:         "21dd776b3c6fc242f685e583389fc730ad1d30d5f32ad7f330938a6116a57147"
    sha256 cellar: :any,                 ventura:        "21dd776b3c6fc242f685e583389fc730ad1d30d5f32ad7f330938a6116a57147"
    sha256 cellar: :any,                 monterey:       "21dd776b3c6fc242f685e583389fc730ad1d30d5f32ad7f330938a6116a57147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f6ac1b9e0763c3f628f637711aa9f252d9ef987ed3f169f7d98850ac683c51b"
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
