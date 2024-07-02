require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.2.16.tgz"
  sha256 "f844fc584ce041647e5e62ef4e0ec9abe270336436ca9958975105161455745d"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "b6cd57f6acee453bd0c30de9044de05f5a5340893062fdd7a852cac1a01a647f"
    sha256                               arm64_ventura:  "a5ecf68a00abf542269746f03c4768347f082dda36e00b2fb044ea5f88a6d641"
    sha256                               arm64_monterey: "f54f5e003ea7bc2dcb6bbbfceedf2649cdfc92fb95dd6eeff818b4a64bad7d1a"
    sha256                               sonoma:         "c508846c2cf2aec5f52f3ec3da9c1aeda16f4893414d85d150b8a4c5eb3f2605"
    sha256                               ventura:        "7ee653547a026df496439966cb369047b90198583d0e61e3592ba5e686e676d9"
    sha256                               monterey:       "429629f522b272a1456abaec0bd65719634487beeda6ca4665dad2aea9ad3c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0f14ba18df4602958a29f786cd0ad468bebcbb9feb22efcbf87b60552c039b4"
  end

  # need node@20, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@20"

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

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    ENV.prepend_path "PATH", Formula["node@20"].bin

    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
