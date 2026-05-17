class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.1.6.tgz"
  sha256 "1f526868af152797136a680d76096ad3e48f0dac6e45411b0c5cc426ffcede47"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d549ecd48c8b1bc19e35a53c2a2ecad2bd3fe35a3d85aeeab8569cd4306fc156"
    sha256 cellar: :any,                 arm64_sequoia: "57b4937c4f51ebd621d1b3c7d435fbda194f1cf1658b29bdd24a363da4ed7025"
    sha256 cellar: :any,                 arm64_sonoma:  "57b4937c4f51ebd621d1b3c7d435fbda194f1cf1658b29bdd24a363da4ed7025"
    sha256 cellar: :any,                 sonoma:        "971057bd1f085ce25748495de792e1ec37ca308e2e29b8be26a3bed521a6e763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11af051e822fa9af09e4cb6b9e1a220547dc9b2add60d33ba6ea3e48e72fabf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ba992739437f046667a1e0620c1c3ce9e3e609496c2045fd1c86ddc01c7cc7d"
  end

  depends_on "node@24"

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
