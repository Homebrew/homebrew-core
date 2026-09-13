class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://www.asyncapi.com/tools/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.0.2.tgz"
  sha256 "25ecd3a3c04cf47158bf4572136c3f95aface7c0df63a1c9ab8930c9ee7b7258"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "5c5cbcd602da14f55333f0924f1eeafd1d5754527a1d7573ac2dbe2a89c9af67"
    sha256 cellar: :any, arm64_tahoe:       "5c5cbcd602da14f55333f0924f1eeafd1d5754527a1d7573ac2dbe2a89c9af67"
    sha256 cellar: :any, arm64_sequoia:     "5c5cbcd602da14f55333f0924f1eeafd1d5754527a1d7573ac2dbe2a89c9af67"
    sha256 cellar: :any, arm64_linux:       "f7c49ee63542a8b1104969f711196b78d5bed180e19b564d9f2f9356b05104e6"
    sha256 cellar: :any, x86_64_linux:      "0688d60c63aa25d37ad9839a856f3a978d01cc82d8ad9701f3ef3e6cd09524ee"
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

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    (var/"log/asyncapi").mkpath
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
