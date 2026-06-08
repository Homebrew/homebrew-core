class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.1.7.tgz"
  sha256 "a47c845e1c0168c9b81103d825cc9435346aae6840f3c281256385e8d9832250"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "60afabb49fa2f17cb8ce680ed9acc69759def97731a814e0dcb8237695990951"
    sha256 cellar: :any, arm64_sequoia: "197bf36beeaa2a25092c1e63165c4ad9e945c3e8468017db3b000768110c67db"
    sha256 cellar: :any, arm64_sonoma:  "197bf36beeaa2a25092c1e63165c4ad9e945c3e8468017db3b000768110c67db"
    sha256 cellar: :any, sonoma:        "8b87ee37a298c0bef496d14fa0786dc2bedaf08da771dd40ede4d718e04b46a6"
    sha256 cellar: :any, arm64_linux:   "262c1aac8a4e647114dbd635f40b634d38794df36de5e874c9e46c117a07155f"
    sha256 cellar: :any, x86_64_linux:  "b9b0eae89bc6a18285572945da2cc437ea0c9acb5d0e66cda4af8c10b4148fa5"
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
