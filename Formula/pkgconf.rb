class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://git.sr.ht/~kaniini/pkgconf"
  url "https://distfiles.dereferenced.org/pkgconf/pkgconf-1.9.4.tar.xz"
  sha256 "daccf1bbe5a30d149b556c7d2ffffeafd76d7b514e249271abdd501533c1d8ae"
  license "ISC"

  livecheck do
    url "https://distfiles.dereferenced.org/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "815343d4364c646bf7a13da187de4410fb28e904d1e88bdbc3c1b748144fa10e"
    sha256 arm64_monterey: "04a955f0318ed9ca38199ffb8d99460e6e07025d47d214f476af58cf5e87f16c"
    sha256 arm64_big_sur:  "de4a531046e2bd7f36dda142cc81ffd85d4f1a55373a50a8410780d6960341ca"
    sha256 ventura:        "68181eff1f5d9d4a8f69ce1417a7dce71d8dda83354add9bd83c562041dadfd9"
    sha256 monterey:       "72073817aa63397777e829495cd46ce2a5a7b90283102ae9d00071a2f216de10"
    sha256 big_sur:        "a77b8411b76e8c712859ad2499edcaaa0de6b777a1a7b744c996bb05a2687f4d"
    sha256 x86_64_linux:   "48d8582dc87ae59ffa295d123d69a4f461853cb7cc5898e48837d3613eccd65f"
  end

  def install
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
    ]
    pc_path << if OS.mac?
      pc_path << "/usr/local/lib/pkgconfig"
      pc_path << "/usr/lib/pkgconfig"
      "#{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}"
    else
      "#{HOMEBREW_LIBRARY}/Homebrew/os/linux/pkgconfig"
    end

    pc_path = pc_path.uniq.join(File::PATH_SEPARATOR)

    configure_args = std_configure_args + %W[
      --with-pkg-config-dir=#{pc_path}
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"foo.pc").write <<~EOS
      prefix=/usr
      exec_prefix=${prefix}
      includedir=${prefix}/include
      libdir=${exec_prefix}/lib

      Name: foo
      Description: The foo library
      Version: 1.0.0
      Cflags: -I${includedir}/foo
      Libs: -L${libdir} -lfoo
    EOS

    ENV["PKG_CONFIG_LIBDIR"] = testpath
    system bin/"pkgconf", "--validate", "foo"
    assert_equal "1.0.0", shell_output("#{bin}/pkgconf --modversion foo").strip
    assert_equal "-lfoo", shell_output("#{bin}/pkgconf --libs-only-l foo").strip
    assert_equal "-I/usr/include/foo", shell_output("#{bin}/pkgconf --cflags foo").strip

    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <libpkgconf/libpkgconf.h>

      int main(void) {
        assert(pkgconf_compare_version(LIBPKGCONF_VERSION_STR, LIBPKGCONF_VERSION_STR) == 0);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}/pkgconf", "-L#{lib}", "-lpkgconf"
    system "./a.out"
  end
end
