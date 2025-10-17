class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.14.tgz"
  sha256 "00e1d5557d5eec19b98a78bdd45bb55902260b9c64adc123c5b8ab8e57dbe747"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "dc5894117b57e95c9150c74d709294dd1e58575c8fa4f392d3924b798dade2c4"
    sha256                               arm64_sequoia: "5b2e0a8f8f6d9d331cc2cc54587b8c74496d9accc5c4d5bc1c174b4a719b0f04"
    sha256                               arm64_sonoma:  "0c5040d5fee69bb7cd3d9672d116b5d2a6e1fa2ab7600725077e378a838c9fd9"
    sha256                               sonoma:        "1f8dc71c66fb5aa7b506fc7ef74c8a1a5504cd8ae5fada367a0790c7454c771a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ca387393902cbf534c79eff8f99906f111b091f93b80becd5c170df0601e4d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9524cd404ca0326fe2787510cf75acd37ececd211712cf435c7ce96a6905ac39"
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
