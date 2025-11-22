class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.11.1.tar.gz"
  sha256 "e6b22775e6731312ba118db376616722a7c71bc619fc209cd915c394cf9ea1f5"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "299a693320807751df878a98e55747774164a9ab38fe1ef362d23dcd62dfb6be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ad5226a47bf0b14993e611ec9c56a1f3dc0e56e3bfc4fb8627f510243c9cfef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca05f4d97023dc941af51a6a815c855ba9ac1906a15cd90b683b64c1afbb7b37"
    sha256 cellar: :any_skip_relocation, sonoma:        "278e668bd9caeb5a2da77af908d3fe0db67c22e744cad77f2891c2902529d7e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccc387089a27d0d021809542098b6319a6767e7b4a64ae80917954d71d80dd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "918c5201dbd8043904b6ac9a05e2e0d2c557d4b3bced3161f12601e5b475c132"
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
