class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-20.2.3.tgz"
  sha256 "c7de765bf44f911ced0c77306f9f617338d365a008111f9d573c8924b0139843"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "f0dab83ea4a8a4cf374a51adea947874dc2f4e104933fd9ac8e4b9808576f38c"
    sha256                               arm64_sonoma:  "9eeedaeef345f734af6a3e837aef0b8b4572f957578573e19f0bb1d332826965"
    sha256                               arm64_ventura: "c92274eb2048acd938268c7cd673982a807cb8b246526a1ea4db5fd5f7497d99"
    sha256                               sonoma:        "81840bb6036749c9d2753e73382cdfd374c2ad304a8361bcd82b958cfd26dd6f"
    sha256                               ventura:       "0d69910472c83d57a873db38d4bd0f6eab30d36d143a392748873d5420aaac23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb1d0bca4877c9ff440c7e39a4b1cb00570294b8281261e425ae7e8097675b8"
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
