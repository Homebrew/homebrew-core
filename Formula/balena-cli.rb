require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-14.5.18.tgz"
  sha256 "716f65c337f001f42bc8b3eff40dabc67a528c90581264116f128d8b02b3a8ff"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "e648378af96592b904200539cee7914dbfaff53b8c31cd1e7b9a6d3cb4a4bae5"
    sha256                               arm64_monterey: "ace7d80a25d59f4762b7cf6fb4b1749818aa07553650d4e3eeaba3321ce10789"
    sha256                               arm64_big_sur:  "0c81049835c37e967d91b1d5cc535b26d815def5c75292cbc70d890df0414bee"
    sha256                               ventura:        "ab6a1eab4b6037360f32542a32c9578bb47ea1c76b15635fc7b19ca44f6dad16"
    sha256                               monterey:       "63be920bb65c76177cba88454580db3413ebf06cb3e56d1446f2cddf1f09ee38"
    sha256                               big_sur:        "83aad92fcd11f67e46fa994cf6799d09b90c0cd01f304df0b2fcd4e0e3a4be1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e6b54f260a8a8051ac73478f8f2d149552ddb41a0987978b0ac27e2038574e"
  end

  depends_on "node@14"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    ENV.deparallelize
    system Formula["node@14"].opt_bin/"npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"balena").write_env_script libexec/"bin/balena", PATH: "#{Formula["node@14"].opt_bin}:${PATH}"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modules/mod/"bin"/mod).unlink
          system "make", "-C", node_modules/mod
        end
      end
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
