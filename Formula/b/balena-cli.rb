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
    sha256                               arm64_sonoma:   "c1e8f634c24509500d94507d8ac3d493de746d2ceef3d13508370ce4f66c9bd8"
    sha256                               arm64_ventura:  "e1679abbf9b122329d76ddccfd0aa2bab756b351335921f9cb439415ca3691d7"
    sha256                               arm64_monterey: "9d6b1654fc035d135682db8ab67a5b57dd9041fba80304103ccf0f65aae015bb"
    sha256                               sonoma:         "974d8efc0ffb3f28130e4209024a53a0b3124a0f3701ed2ecf78ce1f227e8ff7"
    sha256                               ventura:        "71908a0a15f0a3d41080c37653290d3fc2cadcb7352a752e3e481fcb09369d0c"
    sha256                               monterey:       "94351f3a85c3575b86d1348a4033206c125c6dc785d7491af5af94f0622403d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de2cee973a66809356728ced96f592408f2df62388f0cb324fa3f4ec0d39d053"
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
