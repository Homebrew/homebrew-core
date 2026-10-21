class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://www.asyncapi.com/tools/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.2.1.tgz"
  sha256 "cfd5d684d9960d4252f01ba8ba88221be641f961157674c911e79d21f15ac685"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9e92c415cc9231cc48bf6bb773f233fbe09561c4ff5887186c86abad3f72d5d4"
    sha256 cellar: :any, arm64_tahoe:       "9e92c415cc9231cc48bf6bb773f233fbe09561c4ff5887186c86abad3f72d5d4"
    sha256 cellar: :any, arm64_sequoia:     "9e92c415cc9231cc48bf6bb773f233fbe09561c4ff5887186c86abad3f72d5d4"
    sha256 cellar: :any, arm64_linux:       "a593dd1b8fe57c7d4e008cc62f6f6d82a1af22c0e757bf822afe244a3be8399d"
    sha256 cellar: :any, x86_64_linux:      "32185fbc311fb95b19f8666d46b07a10c2b8ff06c3908489f3e04b3c26a7ecb4"
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
