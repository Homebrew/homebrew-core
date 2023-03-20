require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.1.1.tgz"
  sha256 "d616f8f4ae52e01930aa8f42302a4f726a4cad82c94ab188a1ca7effd30fbefd"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "d9e9607ab20b4eec7a4227ca1efc7f9d797ab76f6046d510740523637f0dfd0b"
    sha256                               arm64_monterey: "c89a36eef5bc3ece7fd21a6c09f6c4c0a9729018a6a22dbf2e1db15e4b463c74"
    sha256                               arm64_big_sur:  "55e892c1f8c993a1be38d67a6d6e1c1381df4f6216caa1ab843715a963b3df01"
    sha256                               ventura:        "7e18aa86d01f14cec881628b8058e93ec6403a098ab90c9ff7c440277bc5936c"
    sha256                               monterey:       "8908a5b603383019519b5c364d5314a1c26cc17c7d3605ab4dcaa817b5f2ea82"
    sha256                               big_sur:        "8363376a8fa5fa966224ade7e057fd2c356e3f8bb099c22c9028500bb1cde9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92e55126807d7a06fabe37bf8c1d0ef09a91e876b38d258b45397c5d102eaa9"
  end

  # Match deprecation date of `node@14`.
  # TODO: Remove if migrated to `node@18` or `node`. Update date if migrated to `node@16`.
  # Issue ref: https://github.com/balena-io/balena-cli/issues/2221
  # Issue ref: https://github.com/balena-io/balena-cli/issues/2403
  deprecate! date: "2023-04-30", because: "uses deprecated `node@14`"

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
