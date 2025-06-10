class CedraCli < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://cedra.network/"
  url "https://github.com/cedra-labs/cedra/archive/refs/tags/cedra-cli-v7.3.1.tar.gz"
  sha256 "904d46a492d47eaaedd3085ae939b9e5fade0d999702cbb826ed295b65f9952e"
  license "Apache-2.0"
  head "https://github.com/cedra-labs/cedra.git", branch: "testnet"

  livecheck do
    url :stable
    regex(/^cedra-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

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
