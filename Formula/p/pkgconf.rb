class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-3.0.11.tar.xz"
  mirror "https://github.com/pkgconf/pkgconf/releases/download/pkgconf-3.0.11/pkgconf-3.0.11.tar.xz"
  mirror "http://fresh-center.net/linux/misc/pkgconf-3.0.11.tar.xz"
  sha256 "d0cd841bc8e55b9da888106c00dc256d05b7d1d8e5a46f4be4eb4c5125bd2dc4"
  license "ISC"
  compatibility_version 3

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+\.\d+(?:\.[1-8]?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    manifest_sha256 "c1445e36a170f35a5317ac52d7f51e9f1196b3962333ce1903f53be3fe8c3273"
    sha256 arm64_golden_gate: "f5da9ea7e060cd8a7d06e31bdb76dbf74e5d46d77b6657d0573ba1d548216d33"
    sha256 arm64_tahoe:       "84d9b76f2382bca438590bb86a0e1d464147ec70d0bc9a20c25b665c29535aa3"
    sha256 arm64_sequoia:     "984325551072d74b5c32e4c0a48464250612eaf835c39f8b23425fbaf7d3cbc1"
    sha256 arm64_linux:       "1d8dc2d266572d5491b094de900891372681eb9a58b58d1dc4871fe6da145010"
    sha256 x86_64_linux:      "4657c8c704d846d6b2a0b7e3a7d44513c7f9fe22721debe1a6292b02226f7c62"
  end

  head do
    url "https://github.com/pkgconf/pkgconf.git", branch: "main"

    # Using a resource to avoiding dependency tree from brew `meson` or `muon`.
    # The version should align to available HTTP mirror rather than latest.
    resource "muon" do
      url "https://dl.muon.build/v0.7.1/muon-v0.7.1.tar.gz"
      mirror "https://distfiles.alpinelinux.org/distfiles/edge/muon-v0.7.1.tar.gz"
      mirror "http://distfiles.alpinelinux.org/distfiles/edge/muon-v0.7.1.tar.gz"
      sha256 "956b5a74f7852ec4c57a11825dac79052da878da78f507bee1a0ef955053fbbb"

      livecheck do
        url "https://gitlab.alpinelinux.org/alpine/aports/-/raw/master/main/muon/APKBUILD"
        regex(/^pkgver=v?(\d+(?:\.\d+)+)$/i)
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

    sdk_root = MacOS.sdk_path if OS.mac?
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
        -Dwith-system-includedir=#{sdk_root}/usr/include
        -Dwith-system-libdir=/usr/lib
      ]

      system "muon", "meson", "setup", "build", *args, *std_meson_args
      system "muon", "-C", "build", "samu"
      system "muon", "-C", "build", "install"
    else
      args = %W[
        --disable-silent-rules
        --with-pkg-config-dir=#{pc_path.uniq.join(File::PATH_SEPARATOR)}
        --with-system-includedir=#{sdk_root}/usr/include
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
