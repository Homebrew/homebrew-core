require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.0.4.tgz"
  sha256 "6d2c69e797f0dbd90b45822838e69f5604e5675bc6e134d28afc03f19ca77761"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "5c8966d6bc49ef175c5c6536503e53ed8c998e876ff2f740dfb79edaaecc9c47"
    sha256                               arm64_ventura:  "5272577d38b30c7a8144bc6963574287c38ada67c1d1a85d0c02432ca0424ca4"
    sha256                               arm64_monterey: "20150e870a4301b63b86c89e64243136a654818f6cd2664e8f6638af18359370"
    sha256                               sonoma:         "c5c6cc82f7d79e660383f12a2ae7fa1ed42a866258af9ff3b44a45370cc15d76"
    sha256                               ventura:        "055cee209a8bebd1cee1ab8d9a07e6316c4eb5d2bf6cbafdfcbc3bdb7aa8cb85"
    sha256                               monterey:       "e947c84411ece52ea3b1c874a7dfafa6dd966bf676d4bc8380d0da12a9f91338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a67f316a28e018bd61ea35a9720cc4ec5ae96677fc66b76b1416b3ba22f7aa90"
  end

  # need node@18, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@18"

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
    ENV.prepend_path "PATH", Formula["node@18"].bin

    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
