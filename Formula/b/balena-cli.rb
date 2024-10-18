class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-19.9.0.tgz"
  sha256 "e4bc0da42695757dabc64c1fd71fa95da68672c6908803670ccc80b5fbfc224e"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "eabc067c142134784dd1266e11958006ed4e7bcf16b4c5d4de02b5c39a6a39d4"
    sha256                               arm64_sonoma:  "3dc1c52cbc6ebc44e22761400a17de82d8476807d45f5247b60f64fc1b7bcf23"
    sha256                               arm64_ventura: "abf5fefab161b45d9180f86378f8bb99607252d1f3429f9c5eb2a9f93937ff87"
    sha256                               sonoma:        "ed5b11f555980054579d6b73b6a11b92cc1de3f770b3e84b75fafa2d4145e188"
    sha256                               ventura:       "544c06ad3e51bb7face54d9bb3ff262e23b740a5333330db319133c2658d4c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "569165361802730663a4a7f98a6ff7951ec8820434999cc2b91e6f4468be7c90"
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
