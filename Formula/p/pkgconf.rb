class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-2.5.1.tar.xz"
  mirror "https://fossies.org/linux/misc/pkgconf-2.5.1.tar.xz"
  mirror "http://fresh-center.net/linux/misc/pkgconf-2.5.1.tar.xz"
  sha256 "cd05c9589b9f86ecf044c10a2269822bc9eb001eced2582cfffd658b0a50c243"
  license "ISC"

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "84f26aae5e27d846e00a9fb741dfe3b02a14cb2f81ca4a4246617379cda99fc0"
    sha256 arm64_sequoia: "6fabdc3d0a656e2d505aec4e39b2f8e354601ee141469554fa71eabc3386e18f"
    sha256 arm64_sonoma:  "bc7f9963756598248220da128a5f06ea0e6685aa7cd965a5ce357fcfaad2cdec"
    sha256 arm64_ventura: "8d53ac0deb003f8866315c4c27a1aa4767467c9fa13c912f52cb29e37fbe7916"
    sha256 tahoe:         "ab1a7c8edaffa3a27400174deb4845140bdd56942d9ab2a7bccdf30f7ef74d91"
    sha256 sequoia:       "a074f871aa476dec1101c13b4fcfbb9354a8b35bcb6e056f8411463913632071"
    sha256 sonoma:        "439e8e638986c4423f430719f28cd7c62e8d9a1b87ac658c069fd5da939784f8"
    sha256 ventura:       "e38acbfd930c9588f4d1eabe061b956948aaff32cccb30c457430779c1e4f7f5"
    sha256 arm64_linux:   "abdf9fbefab1d7b7219a619fb5bd44b58c00a71146a43cb24b71700c2ead369e"
    sha256 x86_64_linux:  "9df0ce4d9ebae822b763a9c18565d1596a40b2a2e5849c743e768a99f554f24b"
  end

  head do
    url "https://github.com/pkgconf/pkgconf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
