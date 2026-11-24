class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.44.tgz"
  sha256 "4d1a705c00f93177e755a05f3009f199ba1626207eda3c73bf085f822ee00c90"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    manifest_sha256 "fc795d5b038c7b8ab8134357f62762fe679318a54c2a773f0f4b5a64387d4890"
    sha256 cellar: :any, arm64_golden_gate: "95190652e0b126bb488531a2a0dfd978b51deded4043b1d51fc34e8727c7f039"
    sha256 cellar: :any, arm64_tahoe:       "95190652e0b126bb488531a2a0dfd978b51deded4043b1d51fc34e8727c7f039"
    sha256 cellar: :any, arm64_sequoia:     "95190652e0b126bb488531a2a0dfd978b51deded4043b1d51fc34e8727c7f039"
    sha256 cellar: :any, arm64_linux:       "397b7133ec2ce71545facaa8ac51451259d9922d9ea88fceb0fb44081effdc08"
    sha256 cellar: :any, x86_64_linux:      "11627150a6a37f2d0a1d61646548eea8bb5d1255e52065f6ed5d142fd2725909"
  end

  depends_on "go" => :build
  depends_on "node"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  allow_network_access! :build

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
      bare-buffer
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
