require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.2.0.tgz"
  sha256 "2fa6a5530ba9dea01367ce485520a75a1e06c0acab5252b1c80d8b7464b87841"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "fbe61673aa5c6c7d3871e8eda10f52b41894e942299f25e1178ed98b8c35d922"
    sha256                               arm64_monterey: "07b37e27f226733d73fad4301dd030eaaaffac9e31eaed87346241d78df5a811"
    sha256                               arm64_big_sur:  "0cd9727c17923f34602f0d7cd046d82ce26e85104ca7bffffca6573ae211c206"
    sha256                               ventura:        "a03dcd92e2835e9cf47ad0ad390b54a5ddafcbe653fde732bda3c8619a8658aa"
    sha256                               monterey:       "3b75571aa573a4b723c2b34c884ea7fd0700f87701f3f2c5ee4412c5cc8f3f86"
    sha256                               big_sur:        "797237d5a2638ecdd1d207cb77d856fe08b2afdafdb1cc9b2f005245237109f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a774f23695a92b1cf8f0518e6f78d3ddd0fb6035d50f7cfd3b011c97ce7fe70f"
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
