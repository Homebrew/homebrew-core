class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://spruce.sourceforge.io/gmime/"
  url "https://download.gnome.org/sources/gmime/3.0/gmime-3.0.0.tar.xz"
  sha256 "9d4874fb66d8b09d79ba144d2fbcab6157cf5986268fc4fdc9d98daa12c1a791"

  bottle do
    sha256 "05af2f1ac617529df02b43e6494c480cb442387a96702614ce3eba537d26989a" => :sierra
    sha256 "5b97393ade91622508cd7902a50b2bbeab57d109da9211b6d80053186a84d86a" => :el_capitan
    sha256 "a74503cf97b51a46a7b43f862c1b9cd1f2220b3fc38ba4b56f607b72371f28aa" => :yosemite
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
