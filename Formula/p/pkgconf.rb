class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-2.1.1.tar.xz"
  sha256 "3a224f2accf091b77a5781316e27b9ee3ba82c083cc2e539e08940b68a44fec5"
  license "ISC"

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2a0ec1c727c62fafcb589fdc6e765325a7caaedde89a2fb9d94fdaafdc29c4c8"
    sha256 arm64_ventura:  "9a23ebfbead02b5b57a6c815c3aa1043fa458e4e0476093aeb909c0c70f8471d"
    sha256 arm64_monterey: "fa4a6587a441a45ca8ae4c6d32c4d558c391c219f7c57349f670c304b5bb8656"
    sha256 sonoma:         "48982567258c35a554d37ed2e031ccd0c39e29d133fafc50512eb36691bd7005"
    sha256 ventura:        "c096d91615f491e6899b7eb79647a66b2d201ef69bb14e8353daf941cdae0031"
    sha256 monterey:       "c656440b85c1c44a952334fac8685456dcf3414b95b335ef67cd02551be4d796"
    sha256 x86_64_linux:   "847855571701d1824bb455d49739acc993463864a5227c6dbbc02e49cd9c5a5e"
  end

  head do
    url "https://github.com/pkgconf/pkgconf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "pkg-config", because: "both install `pkg.m4` file"

  def install
    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

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
