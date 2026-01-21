class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-5.0.6.tgz"
  sha256 "4a40fa5ac97cea750d2c3cba482edeba1e181e814625aa5533991fcc5d7cb0b2"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b5c7272d7eb82cc2d4bbf533e069f5a57287ecebc2ddf79235ef17bb7ce22229"
    sha256 cellar: :any,                 arm64_sequoia: "94b889793d1150ae3fc6058f23c0b056d3a018b7db1628b562c39aad5bc7ef0a"
    sha256 cellar: :any,                 arm64_sonoma:  "94b889793d1150ae3fc6058f23c0b056d3a018b7db1628b562c39aad5bc7ef0a"
    sha256 cellar: :any,                 sonoma:        "18174e377c2b1ca4d001d8b6843552480707493319b1db48e66cec8b6d29f1f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56c17852e71eba4346697f614e752dc210611fce72c4c5f93fb3fd4eb143f146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba5066fdae22e20f3d52b13e1d849caa0561b0e462e48f3f50ea6129ad76799"
  end

  depends_on "node"

  def install
    # Set the log directory to var/log/asyncapi
    inreplace "lib/utils/logger.js", /const logDir = .*;/, "const logDir = '#{var}/log/asyncapi';"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"

    (var/"log/asyncapi").mkpath
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
