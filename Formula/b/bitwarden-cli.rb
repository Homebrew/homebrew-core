class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://github.com/bitwarden/clients/archive/refs/tags/cli-v2024.9.0.tar.gz"
  sha256 "72a87d4eccbf80b31b5fe80c485bff90792018de7c983ff5e93911f2201d3684"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "2383245b9a12e0c354dd68c720451de46aae601c12887bde28c949c8bf67d5e6"
    sha256                               arm64_sonoma:  "2a42ac44f92ea430b309bed47be24d4bfc37decd5eeb3eb5a11e8714b5e5664e"
    sha256                               arm64_ventura: "066c34a2d005f4c9d4097d0f573737456e71b74cd633d97200e20669be196a89"
    sha256                               sonoma:        "f01b6466381189ff1daac576f3e41ed9c16f3e00e48647b18a5a6817f9067c19"
    sha256                               ventura:       "f5cb3d914f7173554fe4d8a9c2c7208ab8e1ec433a3f9c645060526de97ea29b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "002a7f7e4b6655fe8f3b7ca8a62fc50954422066483eaedc656524c560e7c26b"
  end

  depends_on "node"

  def install
    system "npm", "ci", "--ignore-scripts"
    cd buildpath/"apps/cli" do
      # The `oss` build of Bitwarden is a GPL backed build
      system "npm", "run", "build:oss:prod", "--ignore-scripts"
      cd "./build" do
        system "npm", "install", *std_npm_args
        bin.install_symlink Dir[libexec/"bin/*"]
      end
    end

    # Remove incompatible pre-built `argon2` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@bitwarden/cli/node_modules"
    (node_modules/"argon2/prebuilds/linux-arm64/argon2.armv8.musl.node").unlink
    (node_modules/"argon2/prebuilds/linux-x64/argon2.musl.node").unlink
    (node_modules/"argon2/prebuilds").each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    generate_completions_from_executable(
      bin/"bw", "completion",
      base_name: "bw", shell_parameter_format: :arg, shells: [:zsh]
    )
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
