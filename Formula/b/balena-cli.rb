class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.0.tgz"
  sha256 "ce0c0207d1465eb0e38f6583940c002d1d2caa565f7b8f5bafa321a192eff6fe"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "ed6fefe866cca01db8fa2235d9c9ced076e9b3562455010ce6d20e772a8edb96"
    sha256                               arm64_sequoia: "c9c51f2aa5c103699b8b0c35fe06bd2faa3ebef73f5e5527c6f7a7c997b7f921"
    sha256                               arm64_sonoma:  "cd94940edb7392900cbe021e364ce7d3551be1b34d97f8f9793ee583fabc168a"
    sha256                               sonoma:        "00c8de91e076ab1f3c0bfc98fe1c0983684a713bed31401c9c3e5c22831fca19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef6fbb6999117953434740f3768651be2ded8527eb474d7cf88db38f82db328d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d74ae2df0180da16578b4917ff80371960e934a15edfb0f3737dac359fcf54"
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
