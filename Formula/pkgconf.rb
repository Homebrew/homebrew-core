class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://git.sr.ht/~kaniini/pkgconf"
  url "https://distfiles.dereferenced.org/pkgconf/pkgconf-1.9.5.tar.xz"
  sha256 "1ac1656debb27497563036f7bffc281490f83f9b8457c0d60bcfb638fb6b6171"
  license "ISC"

  livecheck do
    url "https://distfiles.dereferenced.org/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "dbb851846b6ff3b1df98a0467d53a06d5d920d23447dc9a82ac7ee736f4adfa8"
    sha256 arm64_monterey: "e840286ebdaa867dc929785b03a1b34685786a1810c54f99cb3ee8ceb4ef2987"
    sha256 arm64_big_sur:  "17f2d70fc2d75aba93d39ac6f18cc913138bc6e910a50d3433843373d2b2c207"
    sha256 ventura:        "62ac9c12537479d9187d508964ffeda87d933d05f183f96b4959fbdccbc378b4"
    sha256 monterey:       "ffc635090712aa70f4054641eaad47d6e0a6d0e3aea4e036f7b168351cec1dc4"
    sha256 big_sur:        "9fd89c2aa1c176b0c14793e1d258dfbf5e564da105ef528ca803cf7b144ab171"
    sha256 x86_64_linux:   "4484f0d7faca2e2e728e20ef0019f51867311a655f2f8673a33bda637cedf6b8"
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
