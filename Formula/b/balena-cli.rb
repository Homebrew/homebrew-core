class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.5.tgz"
  sha256 "0f2dcc5ae3786a684da8f9ef01947ced2dbaf9fff6ca80822af6a34d568c6464"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "b012734f8d8d26937344dd3d947edcb3b89790aa35af443adc2ababc0b962b7d"
    sha256                               arm64_sequoia: "3dc0bf6bd2737619b18044db8cf8dccdc4e3ce44d7e3c6b9b8991fa049c8dc77"
    sha256                               arm64_sonoma:  "d854a7d97f071b8258961138d2ad5aa0714e0acaed25ce3f6e403c95c30ce96a"
    sha256                               sonoma:        "ebc94e8b676ab9939a7f594d8711f688f06be2f608d33cfef9b366e7cb69806b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c552c6fbc681b598dc634183ae1198749ba7f0cf04138d9b553cba07e056e302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdf41febad11274d9ce5e1ad66290896c3094acc1bd1bbba4141615323454a47"
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
