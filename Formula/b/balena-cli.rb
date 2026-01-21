class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.30.tgz"
  sha256 "0aa8be4b9881fc94677263ccd1ffbe882db5be3d68fe4cf2f6ff05cea7cad53f"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "002a376ba9853bc7c7eb5f703226378391e79495e87b86bf367cfe9b46bd0fbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a5c2e94a06ddc19cb9a5b30c1b6520e939fb914766a709c67b8682d54414fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a5c2e94a06ddc19cb9a5b30c1b6520e939fb914766a709c67b8682d54414fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "24237dd43eed83e62b2718a80de48aaafde772a744e78a6890adc5f7909146e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95fbbf8b625b3b72904d37eca3d971ec1c3375c57b0e6170b6e3c6521464a89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d4997bb2689e96d3453ce573de9dad417b3f4f86aba41fbe949e4ab017625b"
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

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
