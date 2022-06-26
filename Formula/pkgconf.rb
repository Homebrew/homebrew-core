class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://git.sr.ht/~kaniini/pkgconf"
  url "https://distfiles.dereferenced.org/pkgconf/pkgconf-1.8.0.tar.xz"
  sha256 "ef9c7e61822b7cb8356e6e9e1dca58d9556f3200d78acab35e4347e9d4c2bbaf"
  license "ISC"

  livecheck do
    url "https://distfiles.dereferenced.org/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "de081f7770540f6df757f909825baee091fb2a2a5c938798a9e65824a258a747"
    sha256 arm64_big_sur:  "4eb94e8870b9a8e817dc114e310fbb708d5d05226104087ffa18eac66a59bc65"
    sha256 monterey:       "b1bac03399b7e53e23cc1ecdcc6b47a6faf7e74681f08ddca2b2a679bebc8735"
    sha256 big_sur:        "c5a4e284bb365062326df5947cb459cee868538599b3cbb612d79df2e7c40efa"
    sha256 catalina:       "e14c3c64737060d5514792608c0047e336554762a5e9928ab1dddfd8ee565553"
    sha256 mojave:         "c161289fe2bfc1367be2d4e53465d9ebd80a824eb20630fba1d19d35041b5649"
    sha256 x86_64_linux:   "e0f0f360a8d39ff1e210dc73008952d7374bd86672dc2280396b319227f6dea8"
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
