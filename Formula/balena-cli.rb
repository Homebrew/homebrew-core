require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.2.4.tgz"
  sha256 "99ca77368d04824bad095af0040820959371dc174222767807cb2eff6a96657b"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "ac643f93aa2632695f042bf6e2eb33c695d0369703af50dab525fd4c3f60cb04"
    sha256                               arm64_monterey: "91d9fdd9512a11da68f4d55448ae02c48f16f3a325e31ee4671d8eb32925be42"
    sha256                               arm64_big_sur:  "efa2733ccef22a61e65e2fe4e84f23280940edf89be8bb10d3f7c1b06aa26651"
    sha256                               ventura:        "f65d9cb90ae43275fd165e1dbd39d59791a8917370fc9f7ec4efc0f990cd4727"
    sha256                               monterey:       "7221754b310fb4a5a7193c545d72d694022ded9d56bc9c011446d27808df2354"
    sha256                               big_sur:        "068c62e748d705d13b2c54e33fe9559a1deb6de4ab1645cef9b995d490fe7ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aebbe8f40b1af28fad914e62520d4d59d1f21e5747fdedec01b3b50e5fa369d0"
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
