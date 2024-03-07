require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.0.2.tgz"
  sha256 "1f8940b435c4e54edcbeb54d8d726ed5ef3d4fe3f3a696aa1b7bb23192b0b777"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "46d3251fff77b21bb68ada5c62a1a399ac81de70a6c44e6a72c086a2b7eb08d4"
    sha256                               arm64_ventura:  "84eed9795e7627aafa416a61dd9e205efc60c7b2642aa0e9e54c71e49750ebb0"
    sha256                               arm64_monterey: "9bd3c40b3d5e3daa1b3ffa7211ec9bb55f747aa057e4ca70cde3d31a563fe548"
    sha256                               sonoma:         "1dec00677de136b1514d7dab9a9bf9bc242e381df52c2d11960e2fe9bafb5df8"
    sha256                               ventura:        "affb486c0d21a419fce541d6c76372d668aab97bc5579edb9cd0e3b7cbf2f69c"
    sha256                               monterey:       "288cb0cdf86f5477b3fcb6980c91d63f11a1a147c5beb8189b1dae18385688c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a042c635fe65d470daf70da60a9b2f86b6b1490060d2b28f44685451a62fc6b"
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
