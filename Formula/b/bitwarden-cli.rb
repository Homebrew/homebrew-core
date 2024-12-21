class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://github.com/bitwarden/clients/archive/refs/tags/cli-v2024.12.0.tar.gz"
  sha256 "e0bd25b6be3fe5d8f97a8c3a030bb0a7bd7a01d14403414438ba93b891c30690"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "0c599333015c2dd62b748ac58018b9c6023fde504bd5fb6b0c37bb4649fc8294"
    sha256                               arm64_sonoma:  "ba074b871ccfffc0bbccfcef08683180a5e5350f3d846929857ac2d1959a4967"
    sha256                               arm64_ventura: "42b7b79b95e81a6ba681757e9d082ed057fd9fe7d22dea79e57e490ff8807d64"
    sha256                               sonoma:        "40cafc543e207d0935c892d291b6e369e4fcd7487c6f418471de04863c784b68"
    sha256                               ventura:       "d14312a64978352d422aaaa86c5c0165ab6e120edcaa12d9b33f406f80d824d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3993dcd6661df7b3741aea79355637d5abe2f4dccc59fd4bf295fa304f4cc998"
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
      shell_parameter_format: :arg, shells: [:zsh]
    )
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
