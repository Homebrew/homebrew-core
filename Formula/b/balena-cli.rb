class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.1.3.tgz"
  sha256 "360b470d7ded1ba20efb103e8857c6b512ef91e2e08755e6a16fbe5b843ec4b1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38f82703a8c8dac507326e4c3b3577e32c735d6edc25919326f02e8aa4ed7bbb"
    sha256 cellar: :any,                 arm64_sequoia: "d002e4dbe41c8f961c29007033ff8a3d01e45aade7449c48b71425dcc4c06a88"
    sha256 cellar: :any,                 arm64_sonoma:  "d002e4dbe41c8f961c29007033ff8a3d01e45aade7449c48b71425dcc4c06a88"
    sha256 cellar: :any,                 sonoma:        "2cd5f9b34dda1b5b9f378f874bcd8cf0eb10d95cc4e28bf3891787707098fa77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abb4d83698837a9a129b479abf9dd09d3fc8945fef9aa7a0086fe4662f32c3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efa8003ab6e575e08f8623ee8a90ec488ddbd50acfdb0057556e872ef0a9a3c3"
  end

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
