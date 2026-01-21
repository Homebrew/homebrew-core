class Geomview < Formula
  desc "Interactive 3D viewing program"
  homepage "http://www.geomview.org"
  url "https://deb.debian.org/debian/pool/main/g/geomview/geomview_1.9.5.orig.tar.gz"
  mirror "https://downloads.sourceforge.net/project/geomview/geomview/1.9.5/geomview-1.9.5.tar.gz"
  sha256 "67edb3005a22ed2bf06f0790303ee3f523011ba069c10db8aef263ac1a1b02c0"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url "https://deb.debian.org/debian/pool/main/g/geomview/"
    regex(/href=.*?geomview[._-]v?(\d+(?:\.\d+)+)(?:\.orig)?\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               sonoma:       "9d20121d9c889670a2aac8f7a72d917b7da522ed4c81cde78d634cfd40538ec3"
    sha256                               ventura:      "95e6d434f3176020ae4d59a74d514df63f1bb361dfb092396c16aba2bccaa492"
    sha256                               monterey:     "16501f149c43a7875f49f90b1c419c982d927a74e06a2624e31b12d91cd45dd8"
    sha256                               big_sur:      "5b32a3b889e22a91b57549a11fc2d841c773d1f843886d5d42c003bb8797b0e0"
    sha256                               catalina:     "8fcdf484eb6699c2f4c5bc46dec876ba9b4439d39a2dcc6342f63eec019decf4"
    sha256                               arm64_linux:  "c1bed82f7dbaf22135d79d295197f61a34ec8212080f6d7fb002413b8424e54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ff5407aa61b9c6efadf39cc5831c02b45f924c3926ed9cd1475be4ed81c12796"
  end

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxt"
  depends_on "mesa"
  depends_on "mesa-glu"
  depends_on "openmotif"

  uses_from_macos "zlib"

  on_macos do
    depends_on arch: :x86_64 # https://github.com/orgs/Homebrew/discussions/6025

    # Can be undeprecated if upstream decides to support arm64 macOS
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    # TODO: Make `depends_on :linux` when removing macOS support
    deprecate! date: "2025-09-25", because: :unsupported
    disable! date: "2026-09-25", because: :unsupported
  end

  conflicts_with "clip", because: "both install `clip` binaries"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    (bin/"hvectext").unlink
  end

  test do
    assert_match "Error: Can't open display:", shell_output("DISPLAY= #{bin}/geomview 2>&1", 1)
  end
end
