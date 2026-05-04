class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.1.1.tgz"
  sha256 "32b582f64c200d62f122e303a87f30f985e3dcf3381082ab78db636267146a39"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c0899a86698faaf162eb40ae2568f9b2f95fc0d3a7e7dd09356c1bca3fce16e"
    sha256 cellar: :any,                 arm64_sequoia: "135471b0ff92daaa84c9a0c0e619b43d6a53aa19ea1858b8347a737b35ce9d64"
    sha256 cellar: :any,                 arm64_sonoma:  "135471b0ff92daaa84c9a0c0e619b43d6a53aa19ea1858b8347a737b35ce9d64"
    sha256 cellar: :any,                 sonoma:        "a4b41ce010c74377c965fce5ccc3913a7321a1664faae13c863b231a33a9756b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c9ca4eaffe9b57c75e7c30b18b69d2eb8bb213106589c357c4921378f79ab71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a82c8331a4792852a3ea8982cca085d7b99d03b6c66f3553da3d73f1d0aeca"
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
    modules = %w[
      bare-fs
      bare-os
      bare-url
      bcrypt
      lzma-native
      mountutils
      xxhash-addon
    ]
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{#{modules.join(",")}}/prebuilds/*")
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
