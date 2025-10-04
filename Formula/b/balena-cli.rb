class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.9.tgz"
  sha256 "10b53a7b5b3217e507821424996e933409974f27b621ea7a5cba71b2228a30db"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "283bb54cd897be8a8b7934be506be81bcdb4f9fe2a3d17bb531c45b2033eafff"
    sha256                               arm64_sequoia: "076a480c0d8b5e672bd4ef3c6f5994a8a31906fd8d5df22fb3a2fb609bd8f57f"
    sha256                               arm64_sonoma:  "cb31b5a616424cd8edcc4d840ca9500a8890e67e2de2a34cb98eabfd26e99f37"
    sha256                               sonoma:        "ed031f9133024c454a7caab3eedce14de739029d81c8662a90db6dd45df33f76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c412b6c7b8f0ff1a4df1772e62cb2af144a93c23c74dd0ada4a57a172942a32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d64dbc8c004443b519a942e2f82248d5dc5cd1f3d5290ff4bd219424fc7ef79d"
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
