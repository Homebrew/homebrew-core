class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.6.tgz"
  sha256 "4ac9c8e7c88570fde3d2fba2f65c334d16fd7d420a87e71395660dcf06bb3f12"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "aaa0eab7c13e40456012556b7800a6baca0349775d8d34eae11df5c2401c8044"
    sha256                               arm64_sequoia: "e0b5fdc016c7d204ad46a5445e1c50d2b8699932436c5dd848e91be6f1a2c523"
    sha256                               arm64_sonoma:  "2f59242e07dd76bba433de71a0d0a60da2a7d2aee98e4215f7b52da04d7e5432"
    sha256                               sonoma:        "40e123aca3464cd8d9a79e1b66ae34f1fea2bd95a981b50fd39a2afdddb22601"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e6e7f2f160b6ffe2365a6d31d13bd8b8c01a49aaa3fa12a2f49dc90f907cfc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "227b830928ccd47582a2e6a655bb822fd556107f71146b93661d2166cb68b83c"
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
