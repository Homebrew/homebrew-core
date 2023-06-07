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
    rebuild 1
    sha256 arm64_ventura:  "32e03fdba4310694968c2beec37537cf829facf69e33548d5d666fd5c30d4ecd"
    sha256 arm64_monterey: "a9d22dc757e6c4672df087a6ab6ea363b3753b2b297acb8f83dfef0119aa6c99"
    sha256 arm64_big_sur:  "2b494a106f8dd361fccec2e69db0b2995c7105e7c790bd499130c3d20f942032"
    sha256 ventura:        "ef9c689da45844fc022be700d0953ef80b064ac4fa3477cf21bb694c63f9a30a"
    sha256 monterey:       "389a5f1872cab31a3e5bf6c0326d8a4cd6b6ed6102cd6acdd78ca9a1ab075e48"
    sha256 big_sur:        "9f4124b03a938186d9972cc6dfba1cac05003175982486b3dae19fcf74ab3841"
    sha256 catalina:       "655716591d9872a412572f680b7b80d2c7cae625d1d58420d2e757307d8a616f"
    sha256 x86_64_linux:   "1eae16d58ad46e6a6d8e1e6ca08e27a4fd609620622ca49dba416778bbe73edb"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "gnutls"
  depends_on "libgpg-error"
  depends_on "libtool"

  # Fix compatibility with Python 3.10 or later using Debian patch.
  # ImportError: symbol not found in flat namespace '_PyIOBase_Type'
  patch do
    url "https://sources.debian.org/data/main/libp/libprelude/5.2.0-5/debian/patches/025-Fix-PyIOBase_Type.patch"
    sha256 "cd03b3dc208c2a4168a0a85465d451c7aa521bf0b8446ff4777f2c969be386ba"
  end

  def python3
    "python3.11"
  end

  def install
    # Use the stdlib distutils to work around python bindings install failure:
    # TEST FAILED: .../lib/python3.11/site-packages/ does NOT support .pth files
    # bad install directory or PYTHONPATH
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "bindings/python/Makefile.in",
              "--prefix @prefix@",
              "\\0 --install-lib=#{prefix/Language::Python.site_packages(python3)}"

    ENV["HAVE_CXX"] = "yes"
    args = %W[
      --disable-silent-rules
      --without-valgrind
      --without-lua
      --without-ruby
      --without-perl
      --without-swig
      --without-python2
      --with-python3=#{python3}
      --with-libgnutls-prefix=#{Formula["gnutls"].opt_prefix}
    ]

    system "./configure", *std_configure_args, *args
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

    (testpath/"test.py").write <<~EOS
      import prelude
      idmef = prelude.IDMEF()
      idmef.set("alert.classification.text", "Hello world!")
      print(idmef)
    EOS
    assert_match(/classification:\s*text: Hello world!/, shell_output("#{python3} test.py"))
  end
end
