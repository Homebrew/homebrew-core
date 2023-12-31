require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.4.9.tgz"
  sha256 "f72182b5104ce51902decf1b6bc420650799925c5399ca5cf36c09420f230fca"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "01ada33526b88610328824586c590ba205a8388302e9c97b475cb737ce23b7d9"
    sha256                               arm64_ventura:  "01b07a0d4cc542fd35b6a8d8a13af5cfe28bac8dbd8674f95ee2e608a6438ad6"
    sha256                               arm64_monterey: "8df5ca4d5a83c32b10ac9de29ce200d7008495ee882120a5929d17ffc50d4980"
    sha256                               sonoma:         "6c3818081746dff67c7a5ab25a8b2741861815400c46e36e06c058332a66e89f"
    sha256                               ventura:        "757b68f61fdebb69fffbed9ee39037ab16db9749ee9193d8b571dee1f28d2e5e"
    sha256                               monterey:       "e27d74bdc6105c5c521a1eeea26f69f6c3c9d932a3ab9a2b85b33bb783c200f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ccf03cf6e8ea0541b7f53a690b9ae922e0fc3db028fa2f5b588fcc3693c7a06"
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

    # Remove `oclif` patch, it is a devDependency, see discussions in https://github.com/balena-io/balena-cli/issues/2675
    rm "patches/all/oclif+3.17.2.patch"

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
