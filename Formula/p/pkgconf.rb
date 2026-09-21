class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-3.0.7.tar.xz"
  mirror "https://github.com/pkgconf/pkgconf/releases/download/pkgconf-3.0.7/pkgconf-3.0.7.tar.xz"
  mirror "http://fresh-center.net/linux/misc/pkgconf-3.0.7.tar.xz"
  sha256 "c926ff491cbd9a331a589160811bd97ab1749b4d5198a519338f2cdfabe6940a"
  license "ISC"
  compatibility_version 2

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+\.\d+(?:\.[1-8]?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "3e42e1d7b73409b21ae8397794f50c640049730f771db4cd35b22e73dd9c0835"
    sha256 arm64_tahoe:       "338c66b0d559ed78c2f77c038e141cd7b0060d6fcdf80affd1034509e8ab180c"
    sha256 arm64_sequoia:     "3394224fbc510e07acb45f3ad41d62857cfefe2394e8f71ca2e976b59864d5e6"
    sha256 arm64_sonoma:      "e066c26946cd5f27212a6e03e1745d27feba8aa0d0d0547ce36c793abb55d8ff"
    sha256 arm64_linux:       "801bdc18fd03a143979e2cc987730019307966420604aea19d46d6020ae7c81d"
    sha256 x86_64_linux:      "8aacaf8f20d4c277d425163f3c8e9e5df6611f05cb0c32a8ec1069917efd5ffe"
  end

  head do
    url "https://github.com/pkgconf/pkgconf.git", branch: "main"

    # Using a resource to avoiding dependency tree from brew `meson` or `muon`.
    # The version should align to available HTTP mirror rather than latest.
    # TODO: check on mirrors in future if better alternatives are available.
    resource "muon" do
      url "https://muon.build/releases/v0.6.0/muon-v0.6.0.tar.gz"
      mirror "https://pkg.freebsd.org/ports-distfiles/muon/0.6.0/muon-v0.6.0.tar.gz"
      mirror "http://pkg.freebsd.org/ports-distfiles/muon/0.6.0/muon-v0.6.0.tar.gz"
      sha256 "90a8428bc2178c59b9f7ddd1cb1cc6355f4df0c3ac023f7eefd159ae4f054024"

      livecheck do
        url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/muon/distinfo"
        regex(/muon[._-]v?(\d+(?:\.\d+)+)\.t/i)
      end
    end
  end

  deny_network_access!

  def install
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

    if build.head?
      # Autotools build is planned for removal in pkgconf 3.1
      resource("muon").stage do
        args = ["-Dauto_features=disabled"]
        system "./bootstrap.sh", "build"
        system "build/muon-bootstrap", "meson", "setup", "build", *args, *std_meson_args(prefix: buildpath/"muon")
        system "build/muon-bootstrap", "-C", "build", "samu"
        system "build/muon", "-C", "build", "install"
        ENV.prepend_path "PATH", buildpath/"muon/bin"
      end

      args = %W[
        -Dwith-pkg-config-dir=#{pc_path.uniq.join(File::PATH_SEPARATOR)}
        -Dwith-system-includedir=#{MacOS.sdk_path if OS.mac?}/usr/include
        -Dwith-system-libdir=/usr/lib
      ]

      system "muon", "meson", "setup", "build", *args, *std_meson_args
      system "muon", "-C", "build", "samu"
      system "muon", "-C", "build", "install"
    else
      args = %W[
        --disable-silent-rules
        --with-pkg-config-dir=#{pc_path.uniq.join(File::PATH_SEPARATOR)}
        --with-system-includedir=#{MacOS.sdk_path if OS.mac?}/usr/include
        --with-system-libdir=/usr/lib
      ]

      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end

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
