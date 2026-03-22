class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-24.0.3.tgz"
  sha256 "7960fb725c264db12d350e32bfe264162b117d94fefbacf57a2ef50924dbce61"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30e918ea831b797aae48717469a801364000832635cb277e00b4eff510a112e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8443d6be331aeda3cb14f0338dccb65c6cf5efc57364c0905954ebfbc7b980aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8443d6be331aeda3cb14f0338dccb65c6cf5efc57364c0905954ebfbc7b980aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1fccb23fe40ba474feddbf33eb718843fb662e17bf9792c03baef1cde316ee7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff2318e9e990cbb9672d87221907d2a77c7e3e00c7e6358369af143fd409abac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f65f81f5df1cb3c54ddfda6513358b658a55d096dbbc296d507cc416152919a"
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
