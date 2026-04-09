class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.0.0.tgz"
  sha256 "c5939aca4cb9c64cacb404f78bc1ae242d95a6c07151db1698505ae3ed607327"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "966ff0b86f86e32a7e397003765c796806e0a0998e9e473a377f3d46a8d7593c"
    sha256 cellar: :any,                 arm64_sequoia: "1cf61ab278ae0707914ac18f70ab9ace15bc6d2c279cdcb000d9f0d6a575f84c"
    sha256 cellar: :any,                 arm64_sonoma:  "1cf61ab278ae0707914ac18f70ab9ace15bc6d2c279cdcb000d9f0d6a575f84c"
    sha256 cellar: :any,                 sonoma:        "0eb19ea51d5b2bb701dc566186b33b8e6b83aa2bd7226a8b3facb960e5694350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dfa4934db0c269c77235d553a71580a431feb2689bf02c4557f5c981a279b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c2714c128d47db98239819bcbac0d3fe738ef170a0eecd2590f95feb4781295"
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
