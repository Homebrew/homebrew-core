class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.28.tgz"
  sha256 "68a1c71a3c482bdbc5804e34af6b2b58532eed6fd1ac5ab0fb4910592835e936"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d103661c6ecb4ca1b569884e48ef55b932958df41c4dd05b702b3a996a5174a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10b8fb2b64f2747f8a3dd56e74b810b440c2bb2de63b17170b5df946c248f1ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10b8fb2b64f2747f8a3dd56e74b810b440c2bb2de63b17170b5df946c248f1ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "46ae7263e7a9e0a8a1b835d9465fc9d60e7adca06eca63cc94dd74ced76f8d2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33174444096926dac06c2f441548fcde20f4640346296a2624691a237657d771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b8b042f4774c4e163b27e9ef551672c4b45400bc1f51721eed004ac1fc3f6a"
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
