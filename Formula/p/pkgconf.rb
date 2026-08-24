class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-3.0.6.tar.xz"
  mirror "https://github.com/pkgconf/pkgconf/releases/download/pkgconf-3.0.6/pkgconf-3.0.6.tar.xz"
  mirror "http://fresh-center.net/linux/misc/pkgconf-3.0.6.tar.xz"
  sha256 "c88a653fbabfa2a5857a30f6b6ad6c40dbacc3b7c72cc066e5c7dc4571cbddaa"
  license "ISC"
  compatibility_version 2

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+\.\d+(?:\.[1-8]?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3be583e0665fcf0a9bdf93380bfdf65946c177b5d93a005fcc8d7c7dee638b2e"
    sha256 arm64_sequoia: "c538c816c47b41c9ddbd82303d6c8d82fc2f6f21e3f65137cb4fbec285c225e1"
    sha256 arm64_sonoma:  "936aaf3e6b3fabd21b62d939e225475a1e112c019f013c1e81674e178176013c"
    sha256 tahoe:         "b11e7039b7b611cd40755186f4eafcffcf662b44b40daed8c02b9f95e62e042d"
    sha256 sequoia:       "1e26d8d26082743bdb2afea6145f37bb3611f3c6d11dbe43a18939a51d6a9303"
    sha256 sonoma:        "4d0ac8c0b1ba94184eae9fdae2aef654d1b4c140aa097c3558160d3ab8705598"
    sha256 arm64_linux:   "4568f7e5808f1b40b90437ff45246e5984ca1df1c48e7451fdc72d99c8a11812"
    sha256 x86_64_linux:  "92dd0c5e5a99e10c2b38427cf315cfdc6751183ea7f81ffed11ca1358865ee43"
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
