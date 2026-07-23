class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-3.0.4.tar.xz"
  mirror "https://github.com/pkgconf/pkgconf/releases/download/pkgconf-3.0.4/pkgconf-3.0.4.tar.xz"
  mirror "http://fresh-center.net/linux/misc/pkgconf-3.0.4.tar.xz"
  sha256 "91ce346b47f46b87d680c6928e6c43240b9cdc7a31afbea19f2298de4dbe266d"
  license "ISC"
  compatibility_version 2

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+\.\d+(?:\.[1-8]?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "69175754cf1e6693ff88e5c9d3cb76e0df869482370c61ee477ac82c6607f758"
    sha256 arm64_sequoia: "9690271dab0ec12bf4bc851e00e52f478adf0abeecd1b0e69a990dfd8109b48b"
    sha256 arm64_sonoma:  "1f44499a9102cc4d453313ca09d73af3df983a71a360fb4af3f9c7b3ef5dc436"
    sha256 tahoe:         "f60e946ca966ed3c749861126ef4444ea7c71e091ae0fd01006b971692efed33"
    sha256 sequoia:       "eab6232c957adc518688dbebea3546af91853abe7c394e0d48eacfa4c6f4dbc3"
    sha256 sonoma:        "12b35ac07469252509d15c2513f1ebd210456cb9b64f188710283d72b00453f8"
    sha256 arm64_linux:   "adb44b442ee05dd8bb42aa0f0ce9b44e2e9235a363afc0159511548ecf6d0372"
    sha256 x86_64_linux:  "333e8073cfc25ce6fbba732c6a2ebb6aa6e71473120f85d2319c6653e7cc54fd"
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
