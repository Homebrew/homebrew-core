class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.5.tgz"
  sha256 "6fe4c4471b9f37fdc2ae9ff6060e4f74d531db3621f95bc61f81456e4b6f9f2b"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ef276cc6ef6aaebe0fad616ac5aa19ce9d8ce74bf658bfaf980453bab2f813d5"
    sha256 cellar: :any, arm64_sequoia: "ef276cc6ef6aaebe0fad616ac5aa19ce9d8ce74bf658bfaf980453bab2f813d5"
    sha256 cellar: :any, arm64_sonoma:  "ef276cc6ef6aaebe0fad616ac5aa19ce9d8ce74bf658bfaf980453bab2f813d5"
    sha256 cellar: :any, sonoma:        "97b7f9fa0e52fac3f9e5611619698e45cd6da523fd1e36c96ced49c6725512f2"
    sha256 cellar: :any, arm64_linux:   "f405dbc8489a175a103f8d4c449f249f533ece8f66dbe587fc02e44ad8f85964"
    sha256 cellar: :any, x86_64_linux:  "f77cd84ba64af05bf404c778bfe4998bdc9bb769cf3b61d97131410d954fecaa"
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
