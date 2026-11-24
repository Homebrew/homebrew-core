class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.41.tgz"
  sha256 "7763c78d6282d9fc25862eca710026f51d1f83cad72e8ca5fbc64dabf20df9a2"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    manifest_sha256 "c2bbea018c0b41355e725af845d747e43d3ed627555515e2c0930e1bb7c3916b"
    sha256 cellar: :any, arm64_golden_gate: "42385a73a874d494122324ec7d11a1870e2fb06d476ad2c43f119d7f1b23d386"
    sha256 cellar: :any, arm64_tahoe:       "42385a73a874d494122324ec7d11a1870e2fb06d476ad2c43f119d7f1b23d386"
    sha256 cellar: :any, arm64_sequoia:     "42385a73a874d494122324ec7d11a1870e2fb06d476ad2c43f119d7f1b23d386"
    sha256 cellar: :any, arm64_linux:       "d2e3d3b972c0f0cd82d0e3c7e3cab2511e7e93016879b2e06a2b6763e96b3936"
    sha256 cellar: :any, x86_64_linux:      "636239bf75f39b32e8b7cf33395ea121cb855443d2e47c89d2368b6b87d18b2b"
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
