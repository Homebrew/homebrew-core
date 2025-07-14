class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.1.1.tgz"
  sha256 "2ae5970eaa2f09252e136578ddb68cd6d6fc7aa95e1f3d70a206ee5381060ac4"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "c6fd8168f35edd86ef1ae975d180f426f4c7a77910eb0722cb373f74860dfe4f"
    sha256                               arm64_sonoma:  "01aadab49e31fab288fd0fbc011bd089c89425393312e285d5784bcedca8d85a"
    sha256                               arm64_ventura: "9d7d602d00d1dc91a7f08248d0bfe1e5bf3a960c3750314b5f33324b73479a78"
    sha256                               sonoma:        "f369b15088e1654d1aac4c536421dc5669a4c4cfdc9d7ce1d2706b1dda83ecd8"
    sha256                               ventura:       "93167a2e217454aa4b99a55bfd7c3069d32c5e89c8c3944bb8e1d85ae7d1e925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc4087e3c20bfe2c50d9b1ac31b2dd060b81070786070b20c861ea4707f2bb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebf3fccb9ca6ae40607fc9c8a997c304c3520e0d5f4a88abfeb86c8c51c95850"
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
