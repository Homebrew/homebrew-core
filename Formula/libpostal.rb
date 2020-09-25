class Libpostal < Formula
  desc "C library for parsing/normalizing street addresses around the world"
  homepage "https://github.com/openvenues/libpostal"
  url "https://github.com/openvenues/libpostal/archive/v1.0.0.tar.gz"
  sha256 "3035af7e15b2894069753975d953fa15a86d968103913dbf8ce4b8aa26231644"
  license "MIT"
  head "https://github.com/openvenues/libpostal.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--datadir=#{HOMEBREW_PREFIX}/share/libpostal-data",
                          "--prefix=#{prefix}"

    system "make", "-j#{ENV.make_jobs}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <libpostal/libpostal.h>
      int main(int argc, char **argv) {
          if (!libpostal_setup() || !libpostal_setup_parser()) {
              exit(EXIT_FAILURE);
          }
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpostal", "-o", "test"
    output = shell_output "./test 2>&1", 1
    assert_match output.include?("Error loading transliteration module, dir=\(null\)")
  end
end
