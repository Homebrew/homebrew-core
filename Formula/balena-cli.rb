require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.0.5.tgz"
  sha256 "33cd6fd41dc8674da2217f2e032ae16654e182912e65e481d1d7e5ef5929d984"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "8a8b54266a4ba99eeb77c47785d779670531cde0a932da21d4bf796cf1b1a8cf"
    sha256                               arm64_monterey: "cc1fc5c77ecb9d4411164a483e0a6bd87b34ca69b5b2e88aa09f3b15694c951e"
    sha256                               arm64_big_sur:  "72e029379a2e7f3140c9d64b9efba170321dd1651d17a874b289ce90ee299d57"
    sha256                               ventura:        "5224f955b1d5e5cc3518430a4ec194085b94b82b0560602bfa0465531f3490c9"
    sha256                               monterey:       "2bd519966174eb79b0120694dd2e09b7078e0a03eac7911ea7210d7c7d864558"
    sha256                               big_sur:        "3163055a8d2ab87f29317a5dfec1f850f59946f82f3fe4f7763fd7500f7c36ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3e3ccfc853ea3d62f119532863a92ccaf9e55de0b8ad8f90d7338ac0e7717a6"
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
