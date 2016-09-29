class Libcanberra < Formula
  desc "Implementation of XDG Sound Theme and Name Specifications"
  homepage "http://0pointer.de/lennart/projects/libcanberra/"

  stable do
    url "http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz"
    sha256 "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"

    depends_on "gtk-doc" => :optional
  end

  bottle do
    sha256 "066b33288fa7e3741ef45fc2d59578b4f1cf8141b5e6f9847635555a3436ef00" => :sierra
    sha256 "dc9f8e76c81bb21afedd4deb9b9d9bbf3382f012192e5796658845e2083ca018" => :el_capitan
    sha256 "3d820f8c9747e8658c226483267536c76b3dfdf44a9e14ea1327cb5cf0385ba8" => :yosemite
    sha256 "10c6f3c931a349848b6436d10893e9b1bc5051658f125f6b67ddc1f9319396a0" => :mavericks
  end

  head do
    url "git://git.0pointer.de/libcanberra"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libvorbis"
  depends_on "pulseaudio" => :optional
  depends_on "gstreamer" => :optional
  depends_on "gtk+" => :optional
  depends_on "gtk+3" => :optional

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
    (testpath/"lc.c").write <<-EOS.undent
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
