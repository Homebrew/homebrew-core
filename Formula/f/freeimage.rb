class Freeimage < Formula
  desc "Library for FreeImage, a dependency-free graphics library"
  homepage "https://sourceforge.net/projects/freeimage/"
  url "https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.18.0/FreeImage3180.zip"
  version "3.18.0"
  sha256 "f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd"
  license "FreeImage"
  head "https://svn.code.sf.net/p/freeimage/svn/FreeImage/trunk/"

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

  patch do
    # Apply Debian patches to unbundle libraries and other fixes
    url "https://deb.debian.org/debian/pool/main/f/freeimage/freeimage_3.18.0+ds2-11.debian.tar.xz"
    sha256 "4ebd3a84c696dd650d756a43ec60fe22f5b2e591bc5cf8df94a605c5d740c904"
    apply "patches/Disable-vendored-dependencies.patch",
          "patches/Use-system-dependencies.patch",
          "patches/Fix-macro-redefinition-for-64-bit-integer-types.patch",
          "patches/Fix_compilation_external-static.patch",
          "patches/Use-system-jpeg_read_icc_profile.patch",
          "patches/Fix-libraw-compilation.patch",
          "patches/Fix-libraw-compilation-2.patch",
          "patches/build-without-root.patch",
          "patches/CVE-2019-12211-13.patch"
  end

  def install
    ENV.cxx11

    # Avoid overlinking with `little-cms2`
    ENV.append "LDFLAGS", "-Wl,#{OS.mac? ? "-dead_strip_dylibs" : "--as-needed"}"

    # Update jxrlib path from Debian patch to work with Homebrew's jxrlib
    inreplace "Makefile.gnu", "-I/usr/include/jxrlib", "-I#{Formula["jxrlib"].opt_include}/jxrlib"

    # Update to fix build with OpenEXR 3 on macOS where type has changed
    inreplace "Source/FreeImage/PluginEXR.cpp", /\bImath::Int64\b/, "uint64_t"

    # Remove the bundled libraries and regenerate some Makefiles
    rm_r([*Dir["Source/Lib*"], "Source/ZLib", "Source/OpenEXR"])
    system "bash", "gensrclist.sh"
    system "bash", "genfipsrclist.sh"

    args = ["INCDIR=#{include}", "INSTALLDIR=#{lib}"]
    if OS.mac?
      # Make the Linux Makefiles compatible with macOS
      args += %w[
        SHAREDLIB=lib$(TARGET).$(VER_MAJOR).$(VER_MINOR).dylib
        LIBNAME=lib$(TARGET).dylib
        VERLIBNAME=lib$(TARGET).$(VER_MAJOR).dylib
      ]
      ld_version_args = "-current_version $(VER_MAJOR).$(VER_MINOR) -compatibility_version $(VER_MAJOR)"
      inreplace ["Makefile.gnu", "Makefile.fip"] do |s|
        s.gsub! "-shared -Wl,-soname,$(VERLIBNAME)", "-dynamiclib -install_name $(VERLIBNAME) #{ld_version_args}"

        # Update Debian patch to include `pkgconf ... libwebp`
        s.gsub! " libwebpmux ", " libwebp libwebpmux "
      end
    end

    system "make", "-f", "Makefile.gnu", *args
    system "make", "-f", "Makefile.gnu", "install", *args

    ENV.append "LDFLAGS", "-L#{lib} -lfreeimage"
    system "make", "-f", "Makefile.fip", *args
    system "make", "-f", "Makefile.fip", "install", *args
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
