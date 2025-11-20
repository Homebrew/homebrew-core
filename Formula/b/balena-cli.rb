class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.1.4.tgz"
  sha256 "512d6fbe9e62dd6aae390d927751d9506a16f43885eaa6e65e2dbbb31ba45982"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "985db28a1b8bd9aeeeef40e2a1e50a7df21341a2505b1d1d45dcebbbef0af2af"
    sha256                               arm64_sequoia: "3715c2a6392bd011f01542017c0dfca6823b3298ee315cd0c1c4f97abaa096fa"
    sha256                               arm64_sonoma:  "86b96533bf57a4320896e06b2b676d696ad05d53a39eef6779d5cbb8f2ed5a79"
    sha256                               sonoma:        "63b8abfb36245a990e45983406780af8c9e57aa0bb21ece269a71db556cc4837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efcfd76db01ceaa04645e35a214857fc499ff8ff9725560b9ec8721de1e9b5d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adadf676ea4d276155e13e40ccd5ca3153f8d5b96ca2cb7a6089b2e2f49bc13d"
  end

  # align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@22"

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
    node_modules.glob("{bcrypt,lzma-native,mountutils}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

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
