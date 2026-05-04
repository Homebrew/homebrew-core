class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.1.1.tgz"
  sha256 "32b582f64c200d62f122e303a87f30f985e3dcf3381082ab78db636267146a39"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "273d85fa5a167cefc5d665ce5767f4f34ef6a6c61a530c991733621e2cb3b31b"
    sha256 cellar: :any,                 arm64_sequoia: "342065b4e3acd4b1cd50b99ec6a5a634cf1574ed6313abf753c6e7ddbc609d43"
    sha256 cellar: :any,                 arm64_sonoma:  "342065b4e3acd4b1cd50b99ec6a5a634cf1574ed6313abf753c6e7ddbc609d43"
    sha256 cellar: :any,                 sonoma:        "f40310898a1f88ab4c5ecad081a384ebc13b076152f46e0c48d3d369dc1969c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51ac752197fed6d64bc6d24f6a166dd5682fd7196d50c26fd10640758758f39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8fe52a37990718670afcd80f97338e95c0d27b2369a80bc4ce9c04b1f785b1"
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
