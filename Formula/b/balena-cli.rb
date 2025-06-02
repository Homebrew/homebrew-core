class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.0.5.tgz"
  sha256 "5d3db3b356ec2345ff194ecbd4b485cb64c10b5e1e188ea78bc3fdbb60175f16"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "a18b3eed9b1109c0619b41931c572e63125720ffbb843e0e50a949f28b024ef9"
    sha256                               arm64_sonoma:  "5936b0d5b5593363695f5454ea5d5501e684fa0f7fe804804b8fa521eedacfa5"
    sha256                               arm64_ventura: "52ccb0657a2088f78429601073fdb9873ea91a9b270d6edc9b917f55b34240a6"
    sha256                               sonoma:        "e246676cc72d355be1365201f2e37bf05b5516d37931d81d38c1ba896937d423"
    sha256                               ventura:       "635ca74063f2e2fbe3410cd5d0ad85ba09768488839c2bfe94f007f494dff7ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acd15b926f49d7b25f48afe521839086ac5772dcf9b1ac1df1e94d595401b660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b0ad51869c02efefa417376f455a3200b53409e0b3881ece93112733feb6d2"
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
