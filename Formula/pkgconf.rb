class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://git.sr.ht/~kaniini/pkgconf"
  url "https://distfiles.dereferenced.org/pkgconf/pkgconf-1.9.3.tar.xz"
  sha256 "5fb355b487d54fb6d341e4f18d4e2f7e813a6622cf03a9e87affa6a40565699d"
  license "ISC"

  livecheck do
    url "https://distfiles.dereferenced.org/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6adf23dfb9b483675abc3f53fe0f3e59e5894f819760a7b3344b217cf0326a8c"
    sha256 arm64_monterey: "f6700e419d7a201272559fca5652f16b716a2dc5f9ea6ad96865931181b239c9"
    sha256 arm64_big_sur:  "7533f7fcd23efb90f4e78024782ab71b7117a35929e8381219bcefcd5cc931ea"
    sha256 ventura:        "926063239fbd69673abec90edc042843b803d5837cbd2057e284c6ed94b55606"
    sha256 monterey:       "84b996d472c59021d3e641db0bc6bccc1e7503c58142f29b6657f81669617923"
    sha256 big_sur:        "a9a477d4b51427bb8c1d17cf87063d56e12fbd0ce7eb4776b4b28a03e223b85c"
    sha256 catalina:       "4f6660031db90526c2bc21ac3ce2e58e51c1850a351b13a6941860ecf7b751f0"
    sha256 x86_64_linux:   "4d11d9671a30efd67241ad91535205d62a4a7c292c679a3867e108e266dda085"
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
