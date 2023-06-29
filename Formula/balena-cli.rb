require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.6.1.tgz"
  sha256 "864af8c5ff676fe2b22f5d289fe99d782cfcb36ad719d0c980e2bc374c6cfad0"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "d5da8800c854efd04765647669980596f79158809a551cca13f8424427ca6d48"
    sha256                               arm64_monterey: "7944c9effcc81000b27d34d26558b19ee490021c214de0c056301a40bbe8ca33"
    sha256                               arm64_big_sur:  "69d07e7edc39033c54ad7f384f198e1f2632c5b9c6f5dbcbd9e42a7795bdfe3f"
    sha256                               ventura:        "f61c15a7f4607e5d5042b9636716fc0afd2f9e64e8eb37778cea2197ee3e3f09"
    sha256                               monterey:       "fa0c2fab1bf2b2a6f95379f9b200952dae717bec0573ac29568d239ec0e68ea3"
    sha256                               big_sur:        "b6362de5df88ba1b3975f00c0a39ca435f1357e261c9fcb917d55a6af82227d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3b8fc420e86c0d6fa1534c1671f47aa8df5729b0a80f98f175add6ab8536e8e"
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
