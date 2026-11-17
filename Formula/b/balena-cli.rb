class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.20.tgz"
  sha256 "ce61abe523cbc96f248d5534abe55bf583dde2c183c6bb68b78f214be8fe8d14"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4f262b7f619fbf8b1adf0b2c02c77eb3ad8e9e3ab76ebdfe6e38a5f925fa0360"
    sha256 cellar: :any, arm64_tahoe:       "4f262b7f619fbf8b1adf0b2c02c77eb3ad8e9e3ab76ebdfe6e38a5f925fa0360"
    sha256 cellar: :any, arm64_sequoia:     "4f262b7f619fbf8b1adf0b2c02c77eb3ad8e9e3ab76ebdfe6e38a5f925fa0360"
    sha256 cellar: :any, arm64_linux:       "92972ddbb7f9503242ad0f503c9e154d05079871b045f4b24357dcb97440f588"
    sha256 cellar: :any, x86_64_linux:      "1404955d5ffbaacbbfbe4d62486d3cc910501a7076fc380cf2f0c994b2b35df7"
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
