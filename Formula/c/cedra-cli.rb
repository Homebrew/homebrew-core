class CedraCli < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://cedra.network/"
  url "https://github.com/cedra-labs/cedra/archive/refs/tags/cedra-cli-v7.3.1.tar.gz"
  sha256 "9044008e39f4c10f8a4cfa76783c917914c547c4fb3744a291bfaedcdf3f839e"
  license "Apache-2.0"
  head "https://github.com/cedra-labs/cedra.git", branch: "testnet"

  livecheck do
    url :stable
    regex(/^cedra-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6154f568351e598eb81ebb6e4dffbfe2a26b287f0fbcf66e730950c677d35e51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6154f568351e598eb81ebb6e4dffbfe2a26b287f0fbcf66e730950c677d35e51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6154f568351e598eb81ebb6e4dffbfe2a26b287f0fbcf66e730950c677d35e51"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ba7fc9857ebb2da994bbf21300018553e3b7593d0b7608058ca9e3fdc82b835"
    sha256 cellar: :any_skip_relocation, ventura:       "7ba7fc9857ebb2da994bbf21300018553e3b7593d0b7608058ca9e3fdc82b835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9044008e39f4c10f8a4cfa76783c917914c547c4fb3744a291bfaedcdf3f839e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f9c077c6a31d2befabe3f56b6a9e1713f5113181a8b17ad5b0b52d4a2315fcc"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargo/config.toml
    # Ref: https://github.com/Homebrew/brew/blob/master/Library/Homebrew/extend/ENV/super.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"

    # Use correct compiler to prevent blst from enabling AVX support on macOS
    # upstream issue report, https://github.com/supranational/blst/issues/253
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/cedra"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/cedra key generate --output-file output"))
  end
end
