require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.5.2.tgz"
  sha256 "34624072dc02b9443f9ba77c3062dae2ecf7f0b7b70ba2605d4314a0664ed97c"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "72e8830da20b9d7c1f96c51fc03e10c56547496eee2dd133234a47c0ff42f042"
    sha256                               arm64_monterey: "3c08a0d1252de98b3bd1170a5f0b5a5f8f96a919b9d90261a4eafa0e30d8fe74"
    sha256                               arm64_big_sur:  "cf05e97c689edee1a14d34486a3148e4270eb9ebbfd0221e1a2bac8b6ba781e7"
    sha256                               ventura:        "b998494365cd9cfac384842d921804388ceaff0393cc56f46f9d5578ade5fb32"
    sha256                               monterey:       "cd62fcfe9e4c334b5f7939d2667dc974b950bc214e19b0c8ffda61c9b4ba9a60"
    sha256                               big_sur:        "4b84dd2d06f8b46b4ed2383bff7bf51178040a2bfff1d730ae48240901225acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8a11d2a981b471204e8e0122af0e503b436174fa7b0a433108d3a490f81da74"
  end

  depends_on "node@16"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize
    system Formula["node@16"].opt_bin/"npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"balena").write_env_script libexec/"bin/balena", PATH: "#{Formula["node@16"].opt_bin}:${PATH}"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    (node_modules/"lzma-native/build").rmtree
    (node_modules/"usb").rmtree if OS.linux?

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
