class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.6.tar.gz"
  sha256 "e349e2d80c90ca25a4b25a6f4df4b4c2cedebb01a92edfc0ea49a4a958fba967"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb1ce92a30dcce8ba402d36d1b249d3514f68bbdd977b06c6e1e69a0f5ecc451"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baa5aca1f052927dde34569b33759dc5427a5393bea92fbe13041b74d8ba8392"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "119016575a0d8bb45cb2b46d6f7ab12051bafc5326ca570b680b47bec07da71f"
    sha256 cellar: :any_skip_relocation, ventura:        "7028f1a8d820fdaabeea6260ba1e9f95b60f225939244f3e117c491d4d89bd3f"
    sha256 cellar: :any_skip_relocation, monterey:       "98f73424cec692b8736b8da7675fe07303fd4742827bc6499bfddf5a5d4cf023"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ef28c9cd2b83713daa614d8e36a25ea899668244b71b084e5afe79fd7afb47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f9600cb9245061f30ec8c15b71aaa1e214caf4f610244b7d31d64bde47a476"
  end

  depends_on "cmake" => :build
  depends_on "rustup-init" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init",
      "-qy", "--no-modify-path", "--default-toolchain", "1.64"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "./scripts/cli/build_cli_release.sh", "homebrew"
    bin.install "target/cli/aptos"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
