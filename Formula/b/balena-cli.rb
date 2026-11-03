class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.9.tgz"
  sha256 "dd152566027746d6eb59ad84cb81cfeaab4337dbd1030840d995ca9f516a3373"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7b3228fd1d0bf92e7386e1ca85ebfa4fc68d03a168d81998ef7ea27e30de9fec"
    sha256 cellar: :any, arm64_tahoe:       "7b3228fd1d0bf92e7386e1ca85ebfa4fc68d03a168d81998ef7ea27e30de9fec"
    sha256 cellar: :any, arm64_sequoia:     "7b3228fd1d0bf92e7386e1ca85ebfa4fc68d03a168d81998ef7ea27e30de9fec"
    sha256 cellar: :any, arm64_linux:       "b5d01ea7fff1b04fb48d4c8de943a2021430e8c8c34bcb1e5d5fe9ea44adea9b"
    sha256 cellar: :any, x86_64_linux:      "b8864a256626e86f1d77e0343221d0b980df941078284a44d0f9e27bfb7aa4cc"
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
