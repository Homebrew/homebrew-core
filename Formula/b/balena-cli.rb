class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.6.tgz"
  sha256 "ed446eb845831c9f3ac9cacd82faf8f82fc73300e8ed8bc9c756be8ca74f6118"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ce1d32ddb40cca93ca4b5a5bb79032ed919c3ea169e0ce5f9876311233d59f27"
    sha256 cellar: :any, arm64_tahoe:       "9cbed214ac628793c53d6c583c4a19e9e0d3f0ec874f02d784429f3979186ead"
    sha256 cellar: :any, arm64_sequoia:     "9cbed214ac628793c53d6c583c4a19e9e0d3f0ec874f02d784429f3979186ead"
    sha256 cellar: :any, arm64_sonoma:      "9cbed214ac628793c53d6c583c4a19e9e0d3f0ec874f02d784429f3979186ead"
    sha256 cellar: :any, sonoma:            "349816da35ae442bc7108d590b6b1a8e812661f318ed5017a91604281b079892"
    sha256 cellar: :any, arm64_linux:       "3e0d8fd83014686e3b09010ae5537183264df744d936da49f1f3dc3eccaee1dc"
    sha256 cellar: :any, x86_64_linux:      "82e04044a449b6244b7764c5a62687d42a273f164e435714e178a3946527cc3b"
  end

  depends_on "go" => :build
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

    # Build dependency @balena/compose-parser from vendored Go source
    compose_parser = libexec/"lib/node_modules/balena-cli/node_modules/@balena/compose-parser"
    cd compose_parser do
      ENV["CGO_ENABLED"] = "0"
      system "go", "build", "-C", "lib", *std_go_args(output: "../bin/balena-compose-parser")
    end

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    modules = %w[
      bare-fs
      bare-os
      bare-path
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
