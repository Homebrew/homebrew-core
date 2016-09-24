class Libpostal < Formula
  desc "C library for parsing or normalizing addresses"
  homepage "https://github.com/openvenues/libpostal"
  url "https://github.com/openvenues/libpostal/archive/v0.3.1.tar.gz"
  head "https://github.com/openvenues/libpostal.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "snappy" => :run
  depends_on "pkg-config" => :run

  def install
    system "autoreconf", "-fi", "--warning=no-portability"
    system "./configure", "--prefix=#{prefix}", "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <stdlib.h>
      #include <libpostal/libpostal.h>
      int main(int argc, char **argv) {
          if (!libpostal_setup() || !libpostal_setup_parser()) {
              exit(EXIT_FAILURE);
          }

          address_parser_options_t options = get_libpostal_address_parser_default_options();
          address_parser_response_t *parsed = parse_address("781 Franklin Ave Crown Heights Brooklyn NYC NY 11216 USA", options);

          address_parser_response_destroy(parsed);

          libpostal_teardown();
          libpostal_teardown_parser();
      }
    EOS

    args = shell_output("pkg-config --cflags --libs libpostal").split
    args += %w[test.c -o test]
    system ENV.cc, *args
    system "./test"
  end
end
