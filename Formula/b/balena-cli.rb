class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.31.tgz"
  sha256 "3b7fb188274875c4b1d1b4c68f1becb4de5a33695c41c85aeb4de6281d8ff423"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "abc48a4554fdea7d2a739ce827fa8f876aa22bb3aa4ef700e96dbe4093f9dc68"
    sha256 cellar: :any, arm64_tahoe:       "abc48a4554fdea7d2a739ce827fa8f876aa22bb3aa4ef700e96dbe4093f9dc68"
    sha256 cellar: :any, arm64_sequoia:     "abc48a4554fdea7d2a739ce827fa8f876aa22bb3aa4ef700e96dbe4093f9dc68"
    sha256 cellar: :any, arm64_linux:       "1c2ce5f453a9cdd68b7fd1f1c82c8beac7258e2e3cebdd9468a0cb64301d3c9d"
    sha256 cellar: :any, x86_64_linux:      "cbd95c7365eb6368fbcc9f3ccf3ec83c3a9530ac94687d6cb4aca9294a7a1ab3"
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
