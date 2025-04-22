class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://github.com/bitwarden/clients/archive/refs/tags/cli-v2025.2.0.tar.gz"
  sha256 "2c31f8f66e197d5bcbc656c258d4556c97e49a940cabad3ec76ff3742b5252c7"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "8135a07ebdcea3d1f7ded32a9c3c3f2e44d36149a28ebbfaa3f1a36f9442a9b6"
    sha256                               arm64_sonoma:  "b3e3d00aead0feb9093f8824643bb3bd386bd514bf353744557570d0c1112acf"
    sha256                               arm64_ventura: "081a5a6d709da2f18ead6b1f72a40157016b0e7053ed5d702a20f459dc02319f"
    sha256                               sonoma:        "85b5bf952cf8bc3af074eb591ac3aa23cec31fc51b04fd0e0e89713c6a2a28bc"
    sha256                               ventura:       "a636e9b2000aa701f0458536699da75198acdc202ebab30708285553939b2667"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3ab609bea3ee40e18d0886a20d622791afa6de1bcb48f463f3017f665ef16af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db9064f3684fe40c5090a3e47cec50fdc6f6418581d26cdd4da3065d93e28013"
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

    generate_completions_from_executable(bin/"bw", "completion", shells: [:zsh], shell_parameter_format: :arg)
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
