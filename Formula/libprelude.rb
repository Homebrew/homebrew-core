class Libprelude < Formula
  desc "Universal Security Information & Event Management (SIEM) system"
  homepage "https://www.prelude-siem.org/"
  url "https://www.prelude-siem.org/attachments/download/1395/libprelude-5.2.0.tar.gz"
  sha256 "187e025a5d51219810123575b32aa0b40037709a073a775bc3e5a65aa6d6a66e"
  license "GPL-2.0-or-later"

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgpg-error"
  depends_on "python@3.8"

  def install
    ENV["HAVE_CXX"] = "yes"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-valgrind
      --without-lua
      --without-ruby
      --without-perl
      --without-swig
      --without-python2
      --with-python3=#{Formula["python@3.8"].opt_bin/"python3"}
      --with-libgnutls-prefix=#{Formula["gnutls"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output(bin/"libprelude-config --prefix").chomp
    assert_equal version.to_s, shell_output(bin/"libprelude-config --version").chomp

    (testpath/"test.c").write <<~EOS
      #include <libprelude/prelude.h>

      int main(int argc, const char* argv[]) {
        int ret = prelude_init(&argc, argv);
        if ( ret < 0 ) {
          prelude_perror(ret, "unable to initialize the prelude library");
          return -1;
        }
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lprelude", "test.c", "-o", "test"
    system "./test"
  end
end
