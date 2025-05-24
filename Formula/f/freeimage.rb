class Freeimage < Formula
  desc "Graphics library"
  homepage "https://sourceforge.net/projects/freeimage/"
  license "FreeImage"

  stable do
    url "https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.18.0/FreeImage3180.zip"
    version "3.18.0"
    sha256 "f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd"

    depends_on "pkgconf" => :build
    depends_on "imath"
    depends_on "jpeg-turbo"
    depends_on "jxrlib"
    depends_on "libpng"
    depends_on "libraw"
    depends_on "libtiff"
    depends_on "openexr"
    depends_on "openjpeg"
    depends_on "webp"

    uses_from_macos "zlib"

    # Apply Debian patches to unbundle libraries and fix some CVEs. Debian's
    # unbundle patch is based on Fedora's patch though some differences like
    # LDFLAGS vs. LIBRARIES usage makes the Debian patch more suitable when
    # building on an Ubuntu machine.
    patch do
      url "https://deb.debian.org/debian/pool/main/f/freeimage/freeimage_3.18.0+ds2-11.debian.tar.xz"
      sha256 "4ebd3a84c696dd650d756a43ec60fe22f5b2e591bc5cf8df94a605c5d740c904"
      # Debian patches to unbundle libraries and build without root
      apply "patches/Disable-vendored-dependencies.patch",
            "patches/Use-system-dependencies.patch",
            "patches/build-without-root.patch",
            # fixes for newer `libraw`
            "patches/Fix-macro-redefinition-for-64-bit-integer-types.patch",
            "patches/Fix-libraw-compilation.patch",
            "patches/Fix-libraw-compilation-2.patch",
            # fixes for newer `jpeg-turbo`
            "patches/Fix_compilation_external-static.patch",
            "patches/Use-system-jpeg_read_icc_profile.patch",
            # CVE-2019-12211
            "patches/CVE-2019-12211-13.patch",
            # CVE-2020-21427
            "patches/r1830-minor-refactoring.patch",
            "patches/r1832-improved-BMP-plugin-when-working-with-malicious-images.patch",
            "patches/r1836-improved-BMP-plugin-when-working-with-malicious-images.patch",
            # CVE-2020-22524
            "patches/r1848-improved-PFM-plugin-against-malicious-images.patch",
            # CVE-2020-21428
            "patches/r1877-improved-DDS-plugin-against-malicious-images.patch"
    end

    # Modify Debian patch for Homebrew compatibility like `jxrlib` path
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/53efe785df9a41a00d63a9ff088a9846bceba398/freeimage/debian-to-homebrew.patch"
      sha256 "fb678426fe403a07dc9bd9dd0d18237fcb5f815a0a3660d1757d200fa9b2d23a"
    end

    # Fix build with unbundled `imath` as type change impacts macOS.
    # May be able to remove if upstream updates bundled OpenEXR.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/53efe785df9a41a00d63a9ff088a9846bceba398/freeimage/imath-int64.patch"
      sha256 "e940d5925bcfc9cfd40a01e8d7f45747b49c757e0f7995b6255f228022d1a3d5"
    end

    # Workaround to silence some warnings from unbundled `libtiff` otherwise
    # dependents like `perceptualdiff` will flood warnings as tags are searched
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/53efe785df9a41a00d63a9ff088a9846bceba398/freeimage/libtiff-warning.patch"
      sha256 "ab9281cb3f2a4aa67cb6de15e7876666d5894374087ff9fad635ef6de351e9b1"
    end

    # Makefile.osx isn't ideal for Homebrew use so modify Linux Makefiles for macOS
    patch do
      on_macos do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/53efe785df9a41a00d63a9ff088a9846bceba398/freeimage/macos.patch"
        sha256 "231248bab0a92c7004b33c3c4590f40496f551c818222dda2a4634d4c3edc0ca"
      end
    end
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia:  "0c56e5950270ba19800a0b51d0fb516689c82921c2651c30c9fc17934bfb2fdc"
    sha256 cellar: :any,                 arm64_sonoma:   "be291ccddc2e3618d53dc2f06aced0f31eca4a0f72d19ba2f872f57a4dd748f1"
    sha256 cellar: :any,                 arm64_ventura:  "acdcf908bcc7bf5ce7fe7acf6c7d3de9787872c47687e25951411c07d86d7146"
    sha256 cellar: :any,                 arm64_monterey: "ec0035876daea1189f9e681ac3858c99270b6faab6c9701fe3d83333081feb9b"
    sha256 cellar: :any,                 arm64_big_sur:  "02080c0a6c32413b1e85f6e1393559426b77f0a7e5dcfda406617bc6e46a13e0"
    sha256 cellar: :any,                 sonoma:         "63543926a4a7321b1440319e043dd2c4cb256fb5cd9ea66d910308114f05ac3b"
    sha256 cellar: :any,                 ventura:        "57fd52efb2fe5109a77c46f42affd2192fc94acd0211d74a9045719e2ee54c9f"
    sha256 cellar: :any,                 monterey:       "8118801a64a4b47e2572b45935da12209fffea56393586a53186594f05071f58"
    sha256 cellar: :any,                 big_sur:        "948feca0476789f7061b3a0502aaa7820366a309ebad1abd73ff6b7a0c242402"
    sha256 cellar: :any,                 catalina:       "fabc22f3effecdb629ea6585e005aa09b9d3c3cf73fa0e3021370550e6f8832e"
    sha256 cellar: :any,                 mojave:         "f9b3f364e75ce8f0d61be663ef022d88a9b401d2d675599949ff9b19fbf39bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6c63d08f4adf2395f983ad5f8a51f36ac1e749de9fe6428d056859b199ac6e6"
  end

  head do
    url "https://svn.code.sf.net/p/freeimage/svn/FreeImage/trunk/"

    patch do
      on_macos do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/53efe785df9a41a00d63a9ff088a9846bceba398/freeimage/head-macos.patch"
        sha256 "f113aa6a815584dc604e83c1bf64c00dff6259dd0068f2d10798690d43cc2cb2"
      end
      on_linux do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/53efe785df9a41a00d63a9ff088a9846bceba398/freeimage/head-linux.patch"
        sha256 "dad2e80c19c927c0502142843b9551af869e29bb5555fe3f301f9e588cb74253"
      end
    end
  end

  def install
    if build.stable?
      # OpenEXR 3+ needs at least C++11. Can remove after https://sourceforge.net/p/freeimage/svn/1821/
      ENV.cxx11

      # Avoid overlinking to `little-cms2` and help find installed freeimage library
      ENV.append "LDFLAGS", "-Wl,#{OS.mac? ? "-dead_strip_dylibs" : "--as-needed"} -L#{lib}"

      # Remove the bundled libraries and regenerate some Makefiles
      rm_r([*Dir["Source/Lib*"], "Source/ZLib", "Source/OpenEXR"])
      system "bash", "gensrclist.sh"
      system "bash", "genfipsrclist.sh"
    end

    system "make", "-f", "Makefile.gnu"
    system "make", "-f", "Makefile.gnu", "install", "INCDIR=#{include}", "INSTALLDIR=#{lib}"
    system "make", "-f", "Makefile.fip"
    system "make", "-f", "Makefile.fip", "install", "INCDIR=#{include}", "INSTALLDIR=#{lib}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <FreeImage.h>
      int main() {
         FreeImage_Initialise(0);
         FreeImage_DeInitialise();
         exit(0);
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lfreeimage", "-o", "test"
    system "./test"
  end
end
