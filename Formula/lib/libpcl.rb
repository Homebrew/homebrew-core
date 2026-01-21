class Libpcl < Formula
  desc "C library and API for coroutines"
  homepage "http://www.xmailserver.org/libpcl.html"
  url "http://www.xmailserver.org/pcl-1.12.tar.gz"
  sha256 "e7b30546765011575d54ae6b44f9d52f138f5809221270c815d2478273319e1a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?pcl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 sonoma:       "c2f937aca27092e775dc6c4262a318129560b1e079de3f077a307756ec31a417"
    sha256 cellar: :any,                 ventura:      "7318b096881fc158179da00e979a134736447b31f3c7f1047a78befeb129790c"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "cf0d6f7004ede33ceafaad3b1922a9ea3fefb7903c4060cd84e310df5c4b5f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64a2d65ad2bcbbdcc93eedb2771d85da04a69e1e3b3304c256c68d509bc0de20"
  end

  on_macos do
    depends_on arch: :x86_64

    # Can be undeprecated if upstream decides to support arm64 macOS
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    # TODO: Make linux-only when removing macOS support
    deprecate! date: "2025-09-25", because: :unsupported
    disable! date: "2026-09-25", because: :unsupported
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    args = []
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
