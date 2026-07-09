class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.1.10.tgz"
  sha256 "e570613bc13c3f826e98ba2d6357dc342c16b21bfebbfd0b42a9d14b0865f1e8"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8a5ab347e48b3259275ee987913625129ab694e4ed57d39b9a930ffd0d084e50"
    sha256 cellar: :any, arm64_sequoia: "98c92020850761aa5c42b4130d64baeb69b454270262539822aa100217e8daeb"
    sha256 cellar: :any, arm64_sonoma:  "98c92020850761aa5c42b4130d64baeb69b454270262539822aa100217e8daeb"
    sha256 cellar: :any, sonoma:        "17e137161e1d33de049bdc58560f0c3f1780a1c3bb37fc8b3957e472dd5e3e09"
    sha256 cellar: :any, arm64_linux:   "7b6b1852b9e879467fbeb2b68e8ca75d328564683785380880054abbb3e1770b"
    sha256 cellar: :any, x86_64_linux:  "f1c8e0871eb0342200416d99ee8c16a2e08de45d62746442464806adec6f9074"
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
