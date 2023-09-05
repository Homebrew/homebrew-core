require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.0.0.tgz"
  sha256 "e1dc0b5cefae9950ffea313c5d1abbf0a86ff5d85955d0364e3b9ea05947576f"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "d5b82e558de3a394167f9f187b6589a078e641b74cf8a27e9aba4de36cbf18b7"
    sha256                               arm64_monterey: "1b3f7fdbf0fda78532da67eaf7189bf162a846fc1d2411dbde25a426d790209f"
    sha256                               arm64_big_sur:  "46b4ebeff51922f1e10d98ef366947dd66753e829d3263d6a2bcdbe8a7cf539c"
    sha256                               ventura:        "3973cf05d927d02b5fe9ec9916e8a2ae677dcb62d10afdac76b826757341642e"
    sha256                               monterey:       "f1ccabb8aeed85d2b0b9da0159a03558364c4add918e2ce7c0917602ce97f1df"
    sha256                               big_sur:        "0129d2278d56367004b9551537df060b3a5bd32bc16efe84c69f633993949754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "194f15e04583a2e14d2a2fec9f559c7e25d59226293efcfcd034fe7b01bb75b6"
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
