require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.7.6.tgz"
  sha256 "885ea7ff633f6762e2e76a7dfbd7481ce3065779099cd4dc1f52fdf8f89cc0df"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "25bbc9312747c70ad230a484c879efc7c29a4799a48ee6be3a374b13bea5c66a"
    sha256                               arm64_monterey: "ddaed8fcaa22aa4809dd6cf5cc2afc2ef61d176c43ffb274ff2aea683385fc55"
    sha256                               arm64_big_sur:  "67f8080f9042357c75916be87499365006830c3a19cad8f3638c515d657438ff"
    sha256                               ventura:        "d6339347a7b384b1c0e9bfee18887980dab50d8a878ff2e0922f785e6bdb2052"
    sha256                               monterey:       "0d8c39f3151f1872c6d33589cf820456d8bd5121aa77f0a9d515e53b058afdc3"
    sha256                               big_sur:        "74d62eb80f34f883a6844b97cc3d48943f3ccb4a1a264c734495f3063b6ac471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05efc052154eabe516c2aa942793afddb250fc98a961572b536f99fb978fd935"
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
