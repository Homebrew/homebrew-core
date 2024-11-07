class Libtatsu < Formula
  desc "Library handling the communication with Apple's Tatsu Signing Server (TSS)"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libtatsu/releases/download/1.0.4/libtatsu-1.0.4.tar.bz2"
  sha256 "08094e58364858360e1743648581d9bad055ba3b06e398c660e481ebe0ae20b3"
  license "LGPL-2.1-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"

  uses_from_macos "curl"

  def install
    if build.head?
      system "./autogen.sh", *std_configure_args, "--disable-silent-rules"
    else
      system "./configure", *std_configure_args, "--disable-silent-rules"
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libtatsu/tatsu.h"

      int main(int argc, char* argv[]) {
        char *version = libtatsu_version();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltatsu", "-o", "test"
    system "./test"
  end
end
