class Libcanberra < Formula
  desc "Implementation of XDG Sound Theme and Name Specifications"
  homepage "http://0pointer.de/lennart/projects/libcanberra/"
  url "http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz"
  sha256 "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"

  bottle do
    cellar :any
    rebuild 1
    sha256 "34ff83c6dc8af0afc1f1988ebde1ccb4c17d4604fa6d36567daedef43da3047d" => :catalina
    sha256 "3d32a254ac069ef41b785f6950e3eea625de6faaf99d2402236b451f8c765b05" => :mojave
    sha256 "561aa9aba4e6b5f191b74d3dd1c96de9951e3dc5b696d93abaeaa301aa117bae" => :high_sierra
  end

  head do
    url "git://git.0pointer.de/libcanberra"

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
