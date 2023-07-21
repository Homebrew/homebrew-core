require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.7.5.tgz"
  sha256 "0d4746a007bf7ffa25ba0d7f59224cb4ba0edc1124eaf2bf608c756d450ba29d"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "81dcbeb1e60daaf45403456d63728a66adcdd8572619191b10b8d75fb2e7272f"
    sha256                               arm64_monterey: "47994fccf2f3455d080378e1090dc011f928bc56b644ac421ba21832618e0d55"
    sha256                               arm64_big_sur:  "31fd3d71ba918eb0db7c42c204a196ce18efd1f2b08eee3c993b10a748cbe2d9"
    sha256                               ventura:        "109eed65efa4083f982f52d050c7699cc3eb238ca9d58909c78abd7d50476101"
    sha256                               monterey:       "39654c93146351341cc7b81414152f6b1643f1a38049a6dd757422bdf6aa12bc"
    sha256                               big_sur:        "71e334da6663708d28b52b71dd71dbe3191dd32aae7ca95ee00a75c964c7ab3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8b7064c0bc879d36448994379d562971f259784b40e4bd8a6844484c8b71493"
  end

  depends_on "node"

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
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
