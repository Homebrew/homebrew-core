class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-2.3.0.tar.xz"
  sha256 "3a9080ac51d03615e7c1910a0a2a8df08424892b5f13b0628a204d3fcce0ea8b"
  license "ISC"

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "18c4da47fd2032c4edfac853b772e1a16a745a0c67335b86931fb2bec8c10933"
    sha256 arm64_sonoma:   "4d7c5803943bf2dcc8cb9ff8c838ea4283eeab24f49982df044cbc3031856fd8"
    sha256 arm64_ventura:  "e0b2a95c807578a166fab8467305f1d54db32fe0656a4d6cb746c2356146b074"
    sha256 arm64_monterey: "ac13529811ba6f3e57f7f4048711720d073e10a8797768073626f5d6daabbf76"
    sha256 sequoia:        "9b44fe313d296fa10617d6b58ea1eab78bf217b6f00478ad98b01e0375475472"
    sha256 sonoma:         "1db60da1d512bb109dd455f03856e790a156137f9d77f1f507ac72d538a1c1e2"
    sha256 ventura:        "5f272a6b79920f7c236eaa01d94fc8da99ebc79947a56d1808a19d436571c9c8"
    sha256 monterey:       "802a81f3ca1ea1a14699d6e2359e0ccd30ef310142c6c305b17d881cbd6d2ed0"
    sha256 x86_64_linux:   "67710376078e1191ece25d69214d9ced135195b07c24a386db0d9aee590c8ead"
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
