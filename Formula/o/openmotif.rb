class Openmotif < Formula
  desc "LGPL release of the Motif toolkit"
  homepage "https://motif.ics.com/motif"
  url "https://downloads.sourceforge.net/project/motif/Motif%202.3.8%20Source%20Code/motif-2.3.8.tar.gz"
  sha256 "859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7"
  license "LGPL-2.1-or-later"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "371bb9f35979b5035726d70d03b8e5fee6cf8993b95f5328a77c8423f934c1b7"
    sha256 arm64_sequoia:  "a8bc176639f8fb38b41aab636e20c407232203d408d07098042a68e3f4ed610f"
    sha256 arm64_sonoma:   "088de6041cdf83f4d5ab19861a340937bb78e13d455d1c5819926a8a77842488"
    sha256 arm64_ventura:  "1019a2b092f310c8ee4d777401dd907b59e07f0c7b6ea18735a50932e2f42c1a"
    sha256 arm64_monterey: "7abd4f014f6171882ad37dc0c7eea95d79f80c8ae23dca71341745e83564b211"
    sha256 sonoma:         "7a3a027c94087fbae8276b1b1ea1d5005aedf1e9a5c50f5bb5045f58678ebee9"
    sha256 ventura:        "f812e91446ca3ac40eb384466f591a41548b8a8c48b566f68cb32180a10246b7"
    sha256 monterey:       "14ef0a26ccc456c032334f4013d8938098f8dabcd4297f31b64c787794ed8be9"
    sha256 arm64_linux:    "6853dee96064d53c771ee48fc99c0a93dcd8f503f9cdec71e0a6e715a8cbf899"
    sha256 x86_64_linux:   "48f58afdf62747a75241a1be50fde497d04d74fe09e4385c47e01bcc4a572e4f"
  end

  depends_on "pkgconf" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libice"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxp"
  depends_on "libxt"
  depends_on "xbitmaps"

  uses_from_macos "flex" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # Fix 2-level namespace using MacPorts patch
  patch :p0 do
    on_macos do
      url "https://raw.githubusercontent.com/macports/macports-ports/8c436a9c53a7b786da8d42cda16eead0fb8733d4/x11/openmotif/files/patch-lib-xm-vendor.diff"
      sha256 "697ac026386dec59b82883fb4a9ba77164dd999fa3fb0569dbc8fbdca57fe200"
    end
  end

  def install
    if OS.linux?
      # This patch is needed for Ubuntu 16.04 LTS, which uses
      # --as-needed with ld.  It should no longer
      # be needed on Ubuntu 18.04 LTS.
      inreplace ["demos/programs/Exm/simple_app/Makefile.am", "demos/programs/Exm/simple_app/Makefile.in"],
        /(LDADD.*\n.*libExm.a)/,
        "\\1 -lX11"
    end

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"

    # Avoid conflict with Perl
    mv man3/"Core.3", man3/"openmotif-Core.3"
  end

  test do
    assert_match "no source file specified", pipe_output("#{bin}/uil 2>&1")
  end
end
