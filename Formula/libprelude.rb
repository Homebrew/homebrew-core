class Libprelude < Formula
  desc "Universal Security Information & Event Management (SIEM) system"
  homepage "https://www.prelude-siem.org/"
  url "https://www.prelude-siem.org/attachments/download/1395/libprelude-5.2.0.tar.gz"
  sha256 "187e025a5d51219810123575b32aa0b40037709a073a775bc3e5a65aa6d6a66e"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://www.prelude-siem.org/projects/prelude/files"
    regex(/href=.*?libprelude[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7af71434befcd84ab6e66bc6d355942a81ff492bf732d53b23babd98afd4e045"
    sha256 arm64_big_sur:  "0b66c24df4c249e9038f6673ddbd3c813659798e957da9d6c1bfd9fdb67a8316"
    sha256 monterey:       "9284d8e1a805d7ef1332b2c9d040b8ccc30cdc0b8eb83085d7a4d24811c2a922"
    sha256 big_sur:        "c52daf8e1e41fb0ad7123761ecc4fb3f9e059a96a6440baba997e0cd2812be59"
    sha256 catalina:       "42af699d24654a53f69b6eedf42c71fa7ce87f6ee9c2f72d60e5e8bb7c1e4fde"
    sha256 x86_64_linux:   "7f78270bd579bc35cebe47ffbfe3cb26723f1360edca8482affe7b7ea21904bc"
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgpg-error"
  depends_on "python@3.10"

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
      --with-python3=python#{Language::Python.major_minor_version("python3")}
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
    system ENV.cc, "test.c", "-L#{lib}", "-lprelude", "-o", "test"
    system "./test"
  end
end
