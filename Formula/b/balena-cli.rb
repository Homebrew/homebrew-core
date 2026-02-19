class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-24.0.2.tgz"
  sha256 "1df298a2a6dd164e1e62e8472285200337be60d3d3e9585f175dc27113f46a5c"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7a8e2a5676c903745bbf31c2438b3a8104b127869262e5b90ec5b861127c5a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dc58125f8a33efb2ea16dc3c9552e085eac4545071eda0d536793ce397973a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dc58125f8a33efb2ea16dc3c9552e085eac4545071eda0d536793ce397973a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "479841b807b3a0141f2d72e74c580c369d90b99eb0041807f19d04c88bc646b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ace608cb06e104391f19aa30763d01ccc26dc59bf2ca09ae42753b1c8a32ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad7abd5ea9a5b97bdc9b2cb2423edada5bafe710b9000481ab9b9e7b2c03bdf6"
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
