class Libpostal < Formula
  desc "C library for parsing/normalizing street addresses around the world"
  homepage "https://github.com/openvenues/libpostal"
  url "https://github.com/openvenues/libpostal/archive/v1.0.0.tar.gz"
  sha256 "3035af7e15b2894069753975d953fa15a86d968103913dbf8ce4b8aa26231644"
  head "https://github.com/openvenues/libpostal.git"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    cpus = `sysctl -n hw.ncpu`.strip
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-data-download",
                          "--prefix=#{prefix}",
                          "--datadir=#{prefix}/data"
    system "make", "--jobs=#{cpus}"
    system "make", "install"
    system "#{prefix}/bin/libpostal_data", "download", "all", "#{prefix}/data/libpostal"
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
              libpostal_address_parser_options_t options = libpostal_get_address_parser_default_options();
              libpostal_address_parser_response_t *parsed = libpostal_parse_address("781 Franklin Ave Crown Heights Brooklyn NYC NY 11216 USA", options);
              libpostal_address_parser_response_destroy(parsed);
              libpostal_teardown();
              libpostal_teardown_parser();
          }
        EOS

        system ENV.cc, "test.c", "-I#{prefix}/include", "-L#{prefix}/lib", "-lpostal", "-o", "test"
        system "./test"
      end
end
