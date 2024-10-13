class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-19.1.0.tgz"
  sha256 "fcef2ca3b5d94482df5de59df6e69a81a45c402ce6bc23e5c3225ed278bc07d2"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "b672af9ea4da519663484c89a55c61fd0a514f92203c03a52e6202d51cc9d272"
    sha256                               arm64_sonoma:  "728782d185b5784f9b435e0ab1499fb7e96a53f3ebcd6faf91944604649c5ca1"
    sha256                               arm64_ventura: "58b53e6627003d3dcb1a4a501ce70f568e99703efe429c6adbaee12d8b681c7c"
    sha256                               sonoma:        "395b2330931dd4eeb29539ea9408f0b90263c5634d9e16f06045d08fdece5b63"
    sha256                               ventura:       "0fb3617b361c0c80603d52b8a9038807136696a1c9dbb328f94c80da66026ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be18201dd9b354a8199299a5c7c451e1a0ff716f72ef1b15b05a58bba0f21212"
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
