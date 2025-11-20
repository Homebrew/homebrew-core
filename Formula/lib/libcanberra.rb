class Libcanberra < Formula
  desc "Implementation of XDG Sound Theme and Name Specifications"
  homepage "https://0pointer.de/lennart/projects/libcanberra/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz"
    sha256 "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?libcanberra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "ec6a63b0eb4cea2f117b082fadb5acc4792206193e3a64f8a02dcfdd6abda217"
    sha256 cellar: :any,                 arm64_sequoia:  "710648952f9dde5a4292a1d0911d3da6d471684f86eb2c0192b9a6110ae28acd"
    sha256 cellar: :any,                 arm64_sonoma:   "41b031dfdc5078762fa0e135ef5846d6a067999e1d2fa3ab567846dd19f5ef78"
    sha256 cellar: :any,                 arm64_ventura:  "1874b238a6e087b86523eec9845e8ea16934041295bf2833ae676261dc186204"
    sha256 cellar: :any,                 arm64_monterey: "2407b2f3645eb6d00b7aec1ea237c48a0e7131c8b8d7e5b5d3e8f97d4e07b8ad"
    sha256 cellar: :any,                 arm64_big_sur:  "2183cecb64492002ff553ea1e4cc74be23921dec369d86c37c0950b8cdfa2fcd"
    sha256 cellar: :any,                 sonoma:         "a2822a52008b3d1fdac3f9f1486072a356b17b91149fa747846eea2c44839d3e"
    sha256 cellar: :any,                 ventura:        "07441e73895530de938f0a567885882ed7eef3a3709266b641ab60690f253f84"
    sha256 cellar: :any,                 monterey:       "0da5077b448fcb7b6971cf9544872d5670aff827c8150ea9782c0aebbcb6b1c1"
    sha256 cellar: :any,                 big_sur:        "37f03c26282f804ee5d3c1ae6335c53b494cc89418c017ea3ff3e7c1025dcd12"
    sha256 cellar: :any,                 catalina:       "34ff83c6dc8af0afc1f1988ebde1ccb4c17d4604fa6d36567daedef43da3047d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "74befcfd2bc08601e7ec7cff6548d6a6a8960a9d904340948fbe9513cfc1b620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c25edecba69fd90fbd847fede6df5a01107e469422a2f937fff082a43d6073"
  end

  head do
    url "https://git.0pointer.net/libcanberra.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "libvorbis"

  def install
    system "./autogen.sh" if build.head?

    # ld: unknown option: --as-needed" and then the same for `--gc-sections`
    # Reported 7 May 2016: lennart@poettering.net and mzyvopnaoreen@0pointer.de
    system "./configure", "--prefix=#{prefix}", "--no-create"
    inreplace "config.status", "-Wl,--as-needed -Wl,--gc-sections", ""
    system "./config.status"

    system "make", "install"
  end

  test do
    (testpath/"lc.c").write <<~C
      #include <canberra.h>
      int main()
      {
        ca_context *ctx = NULL;
        (void) ca_context_create(&ctx);
        return (ctx == NULL);
      }
    C
    system ENV.cc, "lc.c", "-I#{include}", "-L#{lib}", "-lcanberra", "-o", "lc"
    system "./lc"
  end
end
