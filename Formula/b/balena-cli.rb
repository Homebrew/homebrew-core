class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.1.9.tgz"
  sha256 "dfdebd70b689620a80b79677b57b3deb2a8f4997890103980d496b3256c74661"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "34bc4d72cbb4935c734f8aad63fb4aa4a5b50fcc08ee2841afd31a50635d5571"
    sha256 cellar: :any, arm64_sequoia: "6c7a4ef4dc1fa198be66b572e6901527110e9ea66c5c6f506a35c758de8bd6a8"
    sha256 cellar: :any, arm64_sonoma:  "6c7a4ef4dc1fa198be66b572e6901527110e9ea66c5c6f506a35c758de8bd6a8"
    sha256 cellar: :any, sonoma:        "9f8d2b3ec5a4d83c7f1f1a92a4264b4c0e0c97a554eee71fb29a0d549befbb7a"
    sha256 cellar: :any, arm64_linux:   "245cb4c06ddbdbb5966fb9588244d66a4a3f401d7f16da259c1c098d2b0b61b4"
    sha256 cellar: :any, x86_64_linux:  "8508fff523b6e76a230ca3f82f8c9495e820bb816639ab453bb753ebac62fbbd"
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
