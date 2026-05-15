class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.1.5.tgz"
  sha256 "2a01cc8668779c7c2b4d9c546e107e0b388d457b3c6eba375e7f9aee75a592f5"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71939f697ca55c8766fdef6ab8d9ffe92174a76fc44ce210be2b1840a7f88be3"
    sha256 cellar: :any,                 arm64_sequoia: "a15e0e2d4459d9e9030fdddd3a2d9435cf4734a7407de79c87a24159cb5ebc4e"
    sha256 cellar: :any,                 arm64_sonoma:  "a15e0e2d4459d9e9030fdddd3a2d9435cf4734a7407de79c87a24159cb5ebc4e"
    sha256 cellar: :any,                 sonoma:        "b06766b3759c81027ca356d671fa68579de4225871d8f429b93d5bbccb509f6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7202657e1e4579123bee74f9d9979518b0ff309f16a02c9a7495024cecf6a9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ee73fee9861d88d29909e44ce17cf80fbbe068f09c68e93bea4d25ce788bc58"
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
