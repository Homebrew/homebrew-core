class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://www.asyncapi.com/tools/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.2.3.tgz"
  sha256 "34f6f2e1de94dc4bb3ad558d91447eb037a488594927f5263c54223267f0e681"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9ff298c824d0b9b0bcc964c91bcd6b7034ead4dbc955b3dde490a08a807de4f4"
    sha256 cellar: :any, arm64_tahoe:       "9ff298c824d0b9b0bcc964c91bcd6b7034ead4dbc955b3dde490a08a807de4f4"
    sha256 cellar: :any, arm64_sequoia:     "9ff298c824d0b9b0bcc964c91bcd6b7034ead4dbc955b3dde490a08a807de4f4"
    sha256 cellar: :any, arm64_linux:       "1fdc0f75930d4d2a2e534d5b0431b63b6d93bf68eaf9dbd435669d70259f879e"
    sha256 cellar: :any, x86_64_linux:      "e25fedd51ce9bff097be40d42f7e89a7c1bd665642c8fe7cad23fdd410cbd4eb"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    # Set the log directory to var/log/asyncapi
    inreplace "lib/utils/logger.js", /const logDir = .*;/, "const logDir = '#{var}/log/asyncapi';"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    term_size_vendor_dir = node_modules/"term-size/vendor"
    rm_r(term_size_vendor_dir) # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (formula_opt_bin("macos-term-size")/"term-size").relative_path_from(macos_dir), macos_dir
    end

    (var/"log/asyncapi").mkpath
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
