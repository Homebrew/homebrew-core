class Libisofs < Formula
  desc "Library to create an ISO-9660 filesystem with various extensions"
  homepage "https://dev.lovelyhq.com/libburnia/libisofs"
  url "http://files.libburnia-project.org/releases/libisofs-1.5.4.tar.gz"
  sha256 "aaa0ed80a7501979316f505b0b017f29cba0ea5463b751143bad2c360215a88e"
  license "GPL-2.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "libzip"

  def install
    # use gnu libtool instead of apple libtool
    inreplace "bootstrap", "libtool", "glibtool"
    # regenerate configure as release uses old version of libtool
    # which causes flat_namespace
    system "./bootstrap"

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <libisofs/libisofs.h>

      int main() {
        int major, minor, micro;
        iso_lib_version(&major, &minor, &micro);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lisofs", "-o", "test"
    system "./test"
  end
end
