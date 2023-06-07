require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.5.1.tgz"
  sha256 "16f92e2e2adabae10cd0cc7b90591cf7bea214a5973f5a28bf26812e295fdeda"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "4b9d62688a32558e1c4a76001958fe1e4d4509bfa559e46202db72a4f687081a"
    sha256                               arm64_monterey: "a23e4dd2b92688ba5530f2e328df7145ca51a9f2384cf08c1f07b35887c55915"
    sha256                               arm64_big_sur:  "3310ebebad0e95f10e9599896cdd07328dd3485ed55877e02427fd90107bd8ec"
    sha256                               ventura:        "07e034f77424622486a6b5d47700d61bbbd99c6a8b64219b5d816a0a080be908"
    sha256                               monterey:       "7e88e55a6e840bd9b1f6d5510296f19c027e06e375d57bf346e5eb64bd6c1420"
    sha256                               big_sur:        "9aeb73d2c159a7a6a804827803bdd5c5f326e22d032b37cb62949cfcdc21d4ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d153bc694287ad7d29058c363fc8b9afe75ac8fbdbbbf726aac33920d7c12dbe"
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
