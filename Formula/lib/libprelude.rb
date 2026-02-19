class Libprelude < Formula
  desc "Universal Security Information & Event Management (SIEM) system"
  homepage "https://www.prelude-siem.org/"
  url "https://deb.debian.org/debian/pool/main/libp/libprelude/libprelude_5.2.0.orig.tar.gz"
  sha256 "187e025a5d51219810123575b32aa0b40037709a073a775bc3e5a65aa6d6a66e"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 2
    sha256 arm64_tahoe:    "ee60f8520bdb4b83e136123a3233c36d1f621a866ddae7cae660b9584234ef8c"
    sha256 arm64_sequoia:  "85b094bb36c75510e7cae400478972591a03082b8164e7b183fd0b014fffcec2"
    sha256 arm64_sonoma:   "2ab78aeb01f7a0d2d369ccc3c91e8c14e0e4b192545a222272e7577ded59d56c"
    sha256 arm64_ventura:  "b036b329b9cd3385fdc29af3504dc3cfe66874dd48e3143816d2809b8be86517"
    sha256 arm64_monterey: "1cbcd9a92e12218283d47970e23e4619c8480018dc5e2f503b5b2b02e689e262"
    sha256 sonoma:         "f3a949405b38d7738f8d94dae6fb90b1561702192e666db623f2c8228d52a320"
    sha256 ventura:        "3a2c08553d695bea452ef9fba367c05eb6eac05a9225083a45c3dd8126c942c8"
    sha256 monterey:       "9cf654ae4238290e9cd8c16e34b41a48dbbfd0d4e1cff034cb69361849f7848e"
    sha256 arm64_linux:    "df3abdca560324d595a18bb32eca2a47509f18fbb876c8c99228adb1c4c59562"
    sha256 x86_64_linux:   "52bd631b4ad679cd32f6f8c46d6e3471d800af3e32d4672009bb05733935766d"
  end

  # As of the deprecation date, the upstream site is down and Repology
  # shows libprelude has been dropped by Fedora, Gentoo and pkgsrc.
  # Last release on 2020-09-11
  deprecate! date: "2024-11-04", because: :unmaintained
  disable! date: "2025-11-04", because: :unmaintained

  depends_on "pkgconf" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "gnutls"
  depends_on "libgpg-error"
  depends_on "libtool"

  # Fix compatibility with Python 3.10 or later using Debian patch.
  # ImportError: symbol not found in flat namespace '_PyIOBase_Type'
  patch do
    url "https://sources.debian.org/data/main/libp/libprelude/5.2.0-5/debian/patches/025-Fix-PyIOBase_Type.patch"
    sha256 "cd03b3dc208c2a4168a0a85465d451c7aa521bf0b8446ff4777f2c969be386ba"
  end

  # Apply Debian patch to fix segmentation fault on arm64 linux
  patch do
    on_linux do
      on_arm do
        url "https://sources.debian.org/data/main/libp/libprelude/5.2.0-5/debian/patches/005-fix_pthread_atfork.patch"
        sha256 "5d3e2961b9901fe2109516c422956f20685da780dfd550d7741f61f5e43f7d0c"
      end
    end
  end

  def python3
    "python3.12"
  end

  def install
    # Work-around for build issue with Xcode 15.3
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1500

    ENV["HAVE_CXX"] = "yes"
    args = %W[
      --disable-silent-rules
      --without-valgrind
      --without-lua
      --without-ruby
      --without-perl
      --without-swig
      --without-python2
      --without-python3
      --with-libgnutls-prefix=#{Formula["gnutls"].opt_prefix}
    ]

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    # This is done by manually install python bindings.
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./bindings/python"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/libprelude-config --prefix").chomp
    assert_equal version.to_s, shell_output("#{bin}/libprelude-config --version").chomp

    (testpath/"test.c").write <<~C
      #include <libprelude/prelude.h>

      int main(int argc, char* argv[]) {
        int ret = prelude_init(&argc, argv);
        if ( ret < 0 ) {
          prelude_perror(ret, "unable to initialize the prelude library");
          return -1;
        }
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lprelude", "-o", "test"
    system "./test"

    (testpath/"test.py").write <<~PYTHON
      import prelude
      idmef = prelude.IDMEF()
      idmef.set("alert.classification.text", "Hello world!")
      print(idmef)
    PYTHON
    assert_match(/classification:\s*text: Hello world!/, shell_output("#{python3} test.py"))
  end
end
