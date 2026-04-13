class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-24.1.3.tgz"
  sha256 "9de922932d8c05ed91bd25978a6f39a13831e1419bea7d086fb1542912870678"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c4ac1ca2911d9a9146d9a74a8a2111a591ea611f0a7a579c1d88917ace10d75"
    sha256 cellar: :any,                 arm64_sequoia: "86ac05d92fd8ef9bc9676b518951e01b4f744336f1fbc5994ddd163f3290757a"
    sha256 cellar: :any,                 arm64_sonoma:  "86ac05d92fd8ef9bc9676b518951e01b4f744336f1fbc5994ddd163f3290757a"
    sha256 cellar: :any,                 sonoma:        "d686f5809f2a76a3876100ae72701d397cc968c878b50a2c191f18a5412cd4d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d00f40e91c8ad049cf62e032b1803ec872fa6f55497755e180470c38394e5305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae6927ccf00b6daf4ca5b1c82bac595b394d2d4e9b721708a3371e7dea6a26f8"
  end

  depends_on "node"

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
    modules = %w[
      bare-fs
      bare-os
      bare-url
      bcrypt
      lzma-native
      mountutils
      xxhash-addon
    ]
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{#{modules.join(",")}}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
