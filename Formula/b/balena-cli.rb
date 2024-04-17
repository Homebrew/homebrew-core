require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.1.10.tgz"
  sha256 "1d4a98f1571e69eea8b60e5535576f72721f925aa883893e304926babfde6426"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "838c4a9269226725ea4b799b380791c5ac14af0406ad53995061742118b980a7"
    sha256                               arm64_ventura:  "029c223af3152d3116759ad66db7493dac0b227eb571d15a1f02abbb7ef84b1f"
    sha256                               arm64_monterey: "3a10c0cdbfb91fd9afc43a71432fa1e06ad0f5708ce85e31be923a22a0da795d"
    sha256                               sonoma:         "9e2c3292128d6d8580b9cca52f4107339566b390722e43496c6faa9eac9e5aa4"
    sha256                               ventura:        "eddc4fd83317c77518be881db97cadcda018a1ab769f5479b3a6905112d2cb2f"
    sha256                               monterey:       "bbfef012d0c3ca372cae7d2f97722396e62a1f27a8a23b05145e6e7033062e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f07176913ae8545d3e8846618d2e55cf162c83dd5e3135b0dd8acf19882e0b"
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
