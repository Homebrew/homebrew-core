class Libcanberra < Formula
  desc "Implementation of XDG Sound Theme and Name Specifications"
  homepage "https://0pointer.de/lennart/projects/libcanberra/"

  stable do
    url "https://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz"
    sha256 "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?libcanberra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "2407b2f3645eb6d00b7aec1ea237c48a0e7131c8b8d7e5b5d3e8f97d4e07b8ad"
    sha256 cellar: :any,                 arm64_big_sur:  "2183cecb64492002ff553ea1e4cc74be23921dec369d86c37c0950b8cdfa2fcd"
    sha256 cellar: :any,                 monterey:       "0da5077b448fcb7b6971cf9544872d5670aff827c8150ea9782c0aebbcb6b1c1"
    sha256 cellar: :any,                 big_sur:        "37f03c26282f804ee5d3c1ae6335c53b494cc89418c017ea3ff3e7c1025dcd12"
    sha256 cellar: :any,                 catalina:       "34ff83c6dc8af0afc1f1988ebde1ccb4c17d4604fa6d36567daedef43da3047d"
    sha256 cellar: :any,                 mojave:         "3d32a254ac069ef41b785f6950e3eea625de6faaf99d2402236b451f8c765b05"
    sha256 cellar: :any,                 high_sierra:    "561aa9aba4e6b5f191b74d3dd1c96de9951e3dc5b696d93abaeaa301aa117bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c25edecba69fd90fbd847fede6df5a01107e469422a2f937fff082a43d6073"
  end

  head do
    url "git://git.0pointer.de/libcanberra", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"
  end

  depends_on "pkg-config" => :build
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
    (testpath/"lc.c").write <<~EOS
      #include <canberra.h>
      int main()
      {
        ca_context *ctx = NULL;
        (void) ca_context_create(&ctx);
        return (ctx == NULL);
      }
    EOS
    system ENV.cc, "lc.c", "-I#{include}", "-L#{lib}", "-lcanberra", "-o", "lc"
    system "./lc"
  end
end
