class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-21.1.9.tgz"
  sha256 "4a2d28cca530a46ca105658aee8b8a722d35f89fc1878d92a1bf47ec005c6b72"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "c6a444a026b65f58d4b92aea49e8d8463fc3734770ecff3b13719ae9c3776715"
    sha256                               arm64_sonoma:  "4e67bc44b7f47840dd4c9ec3089fdf4545fd531e1418f5e07d7eedebdfb52d63"
    sha256                               arm64_ventura: "3ba624fa357493097d93258e585e9d955fe10a11ac736efe2d1a902328befba8"
    sha256                               sonoma:        "da04cdb69b5e23fa9681394777ad32dc8b8960b5767e5c014877c68a295ad718"
    sha256                               ventura:       "945f066a25ca9f2f5d6e6614c2c0a36a6f7ef95506ea0b15e6daf4afac397aa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0fac3051a72be06302957b480f7a89c61ee958bf8a7013b4d3f11c9bfed53d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9965a124318d98642dc396b322c4bbd241df9ee0da74a252cf7a94c92581dab0"
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
