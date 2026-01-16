class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-5.0.5.tgz"
  sha256 "76a3159cf2fac4f2e4c5240a2846312f33413c2332a7cd4666a48e0b75360c28"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77308ac846c097e77091bf9e7f7e26a1f48ae7e0dec2d03f2e2d75abf5cb2699"
    sha256 cellar: :any,                 arm64_sequoia: "bda898bc5c5a913c9c1c71325f0551deaecf1d326d20b50f9c45ac48aa8b712c"
    sha256 cellar: :any,                 arm64_sonoma:  "bda898bc5c5a913c9c1c71325f0551deaecf1d326d20b50f9c45ac48aa8b712c"
    sha256 cellar: :any,                 sonoma:        "8675631e6b3e9262f8d3eeebd266a2eafa043528087f56fb42c15e5a6b7f6690"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a496d87426b0fb97f8ea9ddb026d85f98c8902b39195668b8f29acfe397fa77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929063b2228706607e65eb1c1077bcb4c94301644053aa9458d31bc03f604182"
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
