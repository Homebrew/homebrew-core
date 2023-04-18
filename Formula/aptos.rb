class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.11.tar.gz"
  sha256 "940892f3a808fa2875042ac0761f3307d73898dd3f55948ff80805d34c56e915"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "318f85aec9302b89674d04f6cd01d501b4308c33c10257a2154a64e7f9eec955"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "136cffd81eec22483085cf800b0d7f01d0faf86fd921c13f61cc198f4bdc7f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4554ca97b42f8326b6cd84f541ba39c09a64263fa43261d5590a300eab3b2f5c"
    sha256 cellar: :any_skip_relocation, ventura:        "feb71a2b42b80381a4d590fc53752f35a6bc6df0bccaf66632f0601a67782210"
    sha256 cellar: :any_skip_relocation, monterey:       "9825ea4a302bf965666fc89e835007405b798f957d908140fb2cbb2848e9d3df"
    sha256 cellar: :any_skip_relocation, big_sur:        "c02c488fe436f85d43a9c4c755399400ee2aaa520d86473f00e316e13546c578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b5f1644e14ce3da569aace89a91ce1ac20657b9d47f4af7073d976f3c828c08"
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
