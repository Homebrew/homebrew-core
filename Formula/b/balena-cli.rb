class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-21.1.10.tgz"
  sha256 "1a06acefea002274dd3ca52abd8f92cfbd6e1c7b8e2d4501ac1c157e8f200586"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "8d6c62712c3c1d9132efbb41a4fbeacb1abe03982f440cc443d8296fa3e21911"
    sha256                               arm64_sonoma:  "d16b720b214454cf4be2465a2b49a90845675b98904179a300f21df76c523cea"
    sha256                               arm64_ventura: "e606aaae91fe392d69097216611a0ab94e5952407612ed86b6540558aa5dc757"
    sha256                               sonoma:        "f72a35489c163aa0eaba5275018d6c7d0384ed36968b816bfd3dd5a8359947aa"
    sha256                               ventura:       "3af3dcdc258de80a71d2fda79d313d832b9b19a0549c7c8196f6c28a46cf267a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00fade1ec2f56d67c2f348052a378065ef76493098902432a47f02da7befa725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc3c52235cc34f8bbbd7491f56cf4fe98ce5901e5d12529d7f9d5504c5a8c9e8"
  end

  # need node@20, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@20"

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
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules/"lzma-native/build")
    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
