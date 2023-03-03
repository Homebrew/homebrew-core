class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.7.tar.gz"
  sha256 "ace1884fc1b9f6b3c75f57ac8440cc5735b1e1b3143ee8c106ecf1cf6c8e1045"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e39a5be29f6a600a992a2f6c93cbadb593bd679284c9ab82aff61af8f633b358"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff467fb38fd39d3b43c8c1905a2563d6c86367599618af56b49c7d113eaaf6ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c007bb3405200c37b2346797dba72f3c41addc10f46afe8a3e8413f5f0c2aed8"
    sha256 cellar: :any_skip_relocation, ventura:        "e781d1c7bc27199311b5091ca53e9cdbeb17670024df3a51e8e7983ead24d75c"
    sha256 cellar: :any_skip_relocation, monterey:       "2f3288cabfa1a6b61cef10c2028d11d6532c9b6453b31d01c5086d2096f08f05"
    sha256 cellar: :any_skip_relocation, big_sur:        "b76c6e860f8dc12eb4135769c0b434ed97499f8dadc369a57995546d9eae296a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee85a7a0f840f8411a70cb34d110b4f361d7385542a3e85a2afa841f3905624c"
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
