class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://github.com/bitwarden/clients/archive/refs/tags/cli-v2025.6.1.tar.gz"
  sha256 "73d620b95e3554ed980a582f36e5f8a62d7a5839841179281470bc2b973ad96c"
  license "GPL-3.0-only"
  head "https://github.com/bitwarden/clients.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "9772c36c8aab4b81715e436afb5f4a399ee14f1fb32be9d89a50c5619761b5a5"
    sha256                               arm64_sonoma:  "f086ee3c0bfbd5f1bcb5b94182f52e3c083dd85bfd8733f7eca99b7a1ff61199"
    sha256                               arm64_ventura: "6b49cb1f49bc906daacdc85bc93a41d909aed4d3c7d243fc95a854f7ffa938df"
    sha256                               sonoma:        "b92e64400f954245970ce1ca7b6c020f7419e77751cd3828b00977dacb06a393"
    sha256                               ventura:       "708dc028144ae0e45acf31ddd80f52d3e8f135f18128b594058e38e40068f640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49d41e45a26c550bcadda01c1557fc314c5acdcb8b4a7e71c5463bec829611ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf2c06a2c6880a18b3bb29ae69ae4c9476082de7f2a949332db1ef2920773c29"
  end

  depends_on "node"

  def install
    # Fix to build error with xcode 16.3 for `argon2`
    # Issue ref:
    # - https://github.com/bitwarden/clients/issues/15000
    # - https://github.com/ranisalt/node-argon2/issues/448
    inreplace ["package.json", "apps/cli/package.json"], '"argon2": "0.41.1"', '"argon2": "0.43.0"'

    system "npm", "install", *std_npm_args(prefix: false), "--ignore-scripts"
    cd buildpath/"apps/cli" do
      # The `oss` build of Bitwarden is a GPL backed build
      system "npm", "run", "build:oss:prod", "--ignore-scripts"
      system "npm", "install", *std_npm_args
    end
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built `argon2` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@bitwarden/cli/node_modules"
    node_modules.glob("argon2/prebuilds/linux-*/argon2*.musl.node").map(&:unlink)
    (node_modules/"argon2/prebuilds").each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    generate_completions_from_executable(bin/"bw", "completion", "--shell", shells: [:zsh])
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
