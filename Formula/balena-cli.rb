require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.1.0.tgz"
  sha256 "e9a6480265d2d26a261be7aaa26821ca20a08f8366f35d784c4daddefb83891e"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "e2664653fa86adf90598bcce00c9f0a56b1179085484f8fecc8233a977dd47f6"
    sha256                               arm64_monterey: "f6d47b7150c05c4191103a720f220c6461a4445ac409e00dbb7ffdc8fb8fe95e"
    sha256                               arm64_big_sur:  "bfd77184f0db89a79381d92ec0a8aee26a064a819c25a9f74384073e30d22860"
    sha256                               ventura:        "a54cdbfff58290283e129a0e5c13794bf0ecc59334df498fa048472c2ea930bd"
    sha256                               monterey:       "b8b0f0db86f15205ec9c7e0f23b4ec8ec5e0371272d8191843c2a227a685befe"
    sha256                               big_sur:        "83503f156dfcd1eaa1d36f1216a2745ff1f7da16e8ebcb579e03d08754a4c493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c167b55f80757a1df7abc35ffc7ce5cb171d83a29f7c9cce8147967c02dee63"
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
