class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-19.12.0.tgz"
  sha256 "f70a5e30320380bcb700258221cc7fd1cf8cf97cdbf25622bc96469ad5742bd6"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "53af770fdd90ecd73e901636f200ea4032050e8caa54c39967cb3c2b55f99ff5"
    sha256                               arm64_sonoma:  "9317a092a68070f003e51ec77b379b2f26c1376168176c40c9056924712fa791"
    sha256                               arm64_ventura: "52eddbd7c099378350fb316bb735bad258157ba54a1a83216661d58dfc17ba44"
    sha256                               sonoma:        "cb40ef314eec09990db82fc6f1af9eabeaa24635d35077ed1011558cf1858f3b"
    sha256                               ventura:       "7e6c30e0371168549503131cf232429474883fc760078bd4e317bf64c1457ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c07557262b215d87557149d408290f4e4f4207f37cb4d300835ed40bd91e61f6"
  end

  # need node@20, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@20"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules/"lzma-native/build")
    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
