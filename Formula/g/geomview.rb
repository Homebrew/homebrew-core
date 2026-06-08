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

  bottle do
    rebuild 1
    sha256 sonoma:       "4abe048bc7d51440a13c37b0909f86e3f31156e60c3b46d9bad15d89d443e963"
    sha256 arm64_linux:  "804ee62bf1f5e24cc61b161c0c666d92e2adad235e2bc5a4cc1a36fa71ffa889"
    sha256 x86_64_linux: "84578e983605a136c1a474020e5424035749d299c8e4171e7d8e7e962dfed0a2"
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

  on_macos do
    depends_on arch: :x86_64 # https://github.com/orgs/Homebrew/discussions/6025

    # Can be undeprecated if upstream decides to support arm64 macOS
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    # TODO: Make `depends_on :linux` when removing macOS support
    deprecate! date: "2025-09-25", because: :unsupported
    disable! date: "2026-09-25", because: :unsupported
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
