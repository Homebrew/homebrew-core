require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.0.6.tgz"
  sha256 "06a650db4b3b6ade36bcf834c6bfcd25f90c855693d489bf25e765c492c9b054"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "4031f71263e63bae08cd3ebb1591eaf07c3b520c9ab043d9a24bfa30736abde6"
    sha256                               arm64_monterey: "6fbe3c764a3cbd185fb8871a11a5763bec1d83d68c2991636463825e5fafe9b8"
    sha256                               arm64_big_sur:  "2e309e8468661d55717a5d7bc7ddaac33ccd6d16b6c5c8b62ccd75d8d85033fe"
    sha256                               ventura:        "bc09a03b0574b452487aae5f1d8637da0b8062f17b2452630a786c94a3a044c4"
    sha256                               monterey:       "0034e97cd88d1f148ddef1e70123ebd3be16f4fff42c2d754ac94db3a346ad6b"
    sha256                               big_sur:        "28700befb6fbd4d718591efa8f0ddf2f5aac30163c7da2ba576b673a39391734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "142c90a4b220b64a1c30e67b6d194640659d0bc63f676baa98df818350b127f0"
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
