class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.2.34.tgz"
  sha256 "6530a28686048e831246e16dc9b63c2a9e008c8763eefc66beaf48446c81f2b1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "0e934c20567fb43d589bc58f65996aad07e98ffd3947ceec26f6f080acf20a6a"
    sha256                               arm64_ventura:  "fc289e475103698603d293cc684a49e8e5a7a6c918b787617b8a01bb5934ccd6"
    sha256                               arm64_monterey: "70216f89ef0d94e7a03a2f479f6248a8bb99e8850a646bda7d1fc96c02e637c1"
    sha256                               sonoma:         "a5435dbef0de998886a3e07950da963b8e6a877273390cb193aafe7c2cdaf93c"
    sha256                               ventura:        "69dce0169489fde99758dd31f4282b306ff69d1f9310841338debb8161a08db8"
    sha256                               monterey:       "249375534fb66e2aefc894e379b47bd2039ffb28653000689eab027d8dcc3f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c2a0694115b049885d24746332abe74ee8558e89f92e9a9cb7b7c5b59f590d5"
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
