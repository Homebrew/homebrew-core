class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://spruce.sourceforge.io/gmime/"
  url "https://download.gnome.org/sources/gmime/3.0/gmime-3.0.0.tar.xz"
  sha256 "9d4874fb66d8b09d79ba144d2fbcab6157cf5986268fc4fdc9d98daa12c1a791"

  bottle do
    sha256 "fea94b385a0f6bdb5051d4eb6b5d6f7dbddf5cf550036633080cc127985c96c4" => :sierra
    sha256 "c96f61c8f22a89385537bc6e73950b2521a1a722694d402ea8d0bfa89de443cf" => :el_capitan
    sha256 "c5ee9d15334e6b7c8cebebab59491ea54005c3f68e459c405cc3141fafd9c694" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection" => :recommended
  depends_on "glib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-largefile
      --disable-vala
      --disable-glibtest
    ]

    if build.with? "gobject-introspection"
      args << "--enable-introspection"
    else
      args << "--disable-introspection"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <gmime/gmime.h>
      int main (int argc, char **argv)
      {
        g_mime_init();
        if (gmime_major_version>=3) {
          return 0;
        } else {
          return 1;
        }
      }
      EOS
    flags = `pkg-config --cflags --libs gmime-3.0`.split
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
