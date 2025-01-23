class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-2.3.0.tar.xz"
  mirror "http://distfiles.ariadne.space/pkgconf/pkgconf-2.3.0.tar.xz"
  sha256 "3a9080ac51d03615e7c1910a0a2a8df08424892b5f13b0628a204d3fcce0ea8b"
  license "ISC"
  revision 1

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "6b946f8b716f639a88b6fb05fadf57de8309a53d04d4daef93dda1365f0222e3"
    sha256                               arm64_sonoma:  "bee6257d97fd7331e4b6c1bc7f150a230d7f2f49e9104cf98cc52e04c26fb69d"
    sha256                               arm64_ventura: "a4b704e993c8129fb60951d175733f3d5eb34d3b5bc7c56695b41dab0aa4a047"
    sha256                               sonoma:        "fb3a6a6fcba8172e5e7512080ff0fb802526e4a93c384508d2e4031bd297e697"
    sha256                               ventura:       "3f6b06fa2e6d99fbd6607c32691b1d7fcab827c80a81d70b01264d922aea040c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67699e7fc430708e7e591e1af5d088e719293018e87a9bccd664ad401f18b6f2"
  end

  head do
    url "https://github.com/pkgconf/pkgconf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # FIXME: The bottle is mistakenly considered relocatable on Linux.
  # See https://github.com/Homebrew/homebrew-core/pull/85032.
  pour_bottle? only_if: :default_prefix

  def install
    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
    ]
    pc_path += if OS.mac?
      %W[
        /usr/local/lib/pkgconfig
        /usr/lib/pkgconfig
        #{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}
      ]
    else
      ["#{HOMEBREW_LIBRARY}/Homebrew/os/linux/pkgconfig"]
    end

    args = %W[
      --disable-silent-rules
      --with-pkg-config-dir=#{pc_path.uniq.join(File::PATH_SEPARATOR)}
      --with-system-includedir=#{MacOS.sdk_path_if_needed if OS.mac?}/usr/include
      --with-system-libdir=/usr/lib
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    # Make `pkgconf` a drop-in replacement for `pkg-config` by adding symlink[^1].
    # Similar to Debian[^2], Fedora, ArchLinux and MacPorts.
    #
    # [^1]: https://github.com/pkgconf/pkgconf/#pkg-config-symlink
    # [^2]: https://salsa.debian.org/debian/pkgconf/-/blob/debian/unstable/debian/pkgconf.links?ref_type=heads
    bin.install_symlink "pkgconf" => "pkg-config"
    man1.install_symlink "pkgconf.1" => "pkg-config.1"
  end

  test do
    (testpath/"foo.pc").write <<~PC
      prefix=/usr
      exec_prefix=${prefix}
      includedir=${prefix}/include
      libdir=${exec_prefix}/lib

      Name: foo
      Description: The foo library
      Version: 1.0.0
      Cflags: -I${includedir}/foo
      Libs: -L${libdir} -lfoo
    PC

    ENV["PKG_CONFIG_LIBDIR"] = testpath
    system bin/"pkgconf", "--validate", "foo"
    assert_equal "1.0.0", shell_output("#{bin}/pkgconf --modversion foo").strip
    assert_equal "-lfoo", shell_output("#{bin}/pkgconf --libs-only-l foo").strip
    assert_equal "-I/usr/include/foo", shell_output("#{bin}/pkgconf --cflags foo").strip

    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <libpkgconf/libpkgconf.h>

      int main(void) {
        assert(pkgconf_compare_version(LIBPKGCONF_VERSION_STR, LIBPKGCONF_VERSION_STR) == 0);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/pkgconf", "-L#{lib}", "-lpkgconf"
    system "./a.out"

    # Make sure system-libdir is removed as it can cause problems in superenv
    if OS.mac?
      ENV.delete "PKG_CONFIG_LIBDIR"
      refute_match "-L/usr/lib", shell_output("#{bin}/pkgconf --libs libcurl")
    end
  end
end
