class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://github.com/bitwarden/clients/archive/refs/tags/cli-v2025.1.2.tar.gz"
  sha256 "560b5ed7b6c5091fdd20a90a2cd3fe45e69e583feee4584264143d164e724c83"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "6f9e16447f53708347728157a900de5c32a72965eb048faf0ec2502389306e32"
    sha256                               arm64_sonoma:  "161695a3a1a0ea6cc4bbaa049d220371e091dd78e6e7c77a9ce5bfebc2cd67a0"
    sha256                               arm64_ventura: "894b927c61faac5b5f87dadbbba219b6dc3f26963fd4dff1f2681f3e5fd56b3e"
    sha256                               sonoma:        "f4993e320f093eb5de5e03645a5d5726d60b2ac95896ff8f59dc3ba757e4d56f"
    sha256                               ventura:       "e0ffd39c3e1802e738249b953f3b04d713a72863b207dfb06afe03662a70078f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cfae975a1e94a3d687e725739898677f91d04447f01c4d5729a8c19e5c6be92"
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
