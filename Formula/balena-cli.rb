require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.0.3.tgz"
  sha256 "a8defbfe9f1cbc08841c52286321c1a6d0043da8c6063e330082f2e87621c4e9"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "f5e544b9ea8d97eb61ea5fff604997e01d12c4755b6aac9adc8180f264394c92"
    sha256                               arm64_monterey: "e667976ce75df0cc33bb8afd0b5f40431c0d3dc66bb26c9e56b27403268a7256"
    sha256                               arm64_big_sur:  "8e876f59466b88b0b53369d5d244ea2c3394cf31f30aedf732e2e165cfbc278d"
    sha256                               ventura:        "b31799b2f490542298b7233231f13141df3d4a177ae0af5aee4d05703c33ba3f"
    sha256                               monterey:       "3b9b7c25e6972deb63a0c143edfe00cd86fab8ac234be9bee4f6000eb1faa709"
    sha256                               big_sur:        "26021e0182866632d7f9c108cd964937e8d7400937f41b6434f14d8deff94043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a65813ed2c8eaa8c2d447b053338d0b4f0239b168b4c43f3cbaf31f2da6d1b1"
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
