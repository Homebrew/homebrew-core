class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://github.com/bitwarden/clients/archive/refs/tags/cli-v2025.1.0.tar.gz"
  sha256 "8f209bc9466a65dc34b154ec9f99802583fa61166b73ff68c7973466130ebd50"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "5f917e4796af1cd9f084005739dce3d3473c179201953a217f1faef8945f0d84"
    sha256                               arm64_sonoma:  "13f4661ff08562b8b97887eeac46c1336d82f6956a24b68c516a02e8a9be2a57"
    sha256                               arm64_ventura: "ccbe5baac25d5c8c2c46f748992c2fcf5b06c0238d770885bac034ac426efa72"
    sha256                               sonoma:        "8d84d76dd3b60a183e5d0b358a5638044559213a3da9e4dce2a433947bfafb0e"
    sha256                               ventura:       "5c549a8f14c8155c7c8d7954507d282c9676a9d9cbfc6f6bc9371d1c87e76a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f5c6fc08f14f822ffc022cb544b7d1c4bd7a5b1fb8a5702449e0dfff3188a4"
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
