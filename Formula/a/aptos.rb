class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.14.1.tar.gz"
  sha256 "b4a963bd7e15220ba619f08d63ae06fa6356ba828ec68084a3e7c78de1787ed8"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebfd24bbb0ba34fe13542185e12fde639ca446ac2bab48f058d0e1c0820f0d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eb028b2e571b30a7b67b225ea7f830fb37a0135183f47d481fb6ecca4d6b533"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab6d1a1d2aebdd1d6e4e2770223f1549fa7708d60a2683dbd68010403ba9a437"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d14c64f18328807ca941687e582012790198fcc49d6c3b63d9f17161ca156fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90500cf5ce6cff7f8a5f626bd4e35fb229fd74b032eedf2e812a79d2a021abe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8012dea0e81f2a02f6335474f56bc9659b694e489dc638dbfe762e14ee758f82"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # Use correct compiler to prevent blst from enabling AVX support on macOS
    # upstream issue report, https://github.com/supranational/blst/issues/253
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
