class Devil < Formula
  desc "Cross-platform image library"
  homepage "https://sourceforge.net/projects/openil/"
  revision 3

  stable do
    url "https://downloads.sourceforge.net/project/openil/DevIL/1.7.8/DevIL-1.7.8.tar.gz"
    sha256 "682ffa3fc894686156337b8ce473c954bf3f4fb0f3ecac159c73db632d28a8fd"

    # fix compilation issue for ilur.c
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/3db2f9727cea4a51fbcfae742518c614020fb8f2/devil/patch-src-ILU-ilur-ilur.c.diff"
      sha256 "ce96bc4aad940b80bc918180d6948595ee72624ae925886b1b770f2a7be8a2f9"
    end
  end
  bottle do
    cellar :any
    sha256 "4d26759aad301828515cd26de8a58e712fa23bd746949306f1c88b1eb4b7af27" => :sierra
    sha256 "1953824a6ba55112277ba40ee9604c58b4c93d3b61950583323113fd64ed5ae3" => :el_capitan
    sha256 "bd23907c8dd2202835e8cfb5e03b879aa304a2bdf74481a3d148231b869ae230" => :yosemite
    sha256 "5d77a3dcfed8123738dbfa1d77ea6dd2459688b0acbc35a0fd5dfe4b2cf0fead" => :mavericks
  end

  head do
    url "https://github.com/DentonW/DevIL.git"

    option "with-ilut", "Also build the ILUT library"

    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "homebrew/x11/freeglut" if build.with? "ilut"

    # fix compilation issue for ilur.c
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/3db2f9727cea4a51fbcfae742518c614020fb8f2/devil/patch-DevIL-src-ILU-ilur-ilur.c.diff"
      sha256 "8021ffcd5c9ea151b991c7cd29b49ecea14afdfe07cb04fa9d25ab07d836f7d0"
    end
  end

  option :universal

  depends_on "gcc"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff" => :recommended

  # most compilation issues with clang are fixed in the following pull request
  # see https://github.com/DentonW/DevIL/pull/30
  # see https://sourceforge.net/p/openil/bugs/204/
  # also, even with -std=gnu99 removed from the configure script,
  # devil fails to build with clang++ while compiling il_exr.cpp
  fails_with :clang do
    cause "invalid -std=gnu99 flag while building C++"
  end

  def install
    ENV.universal_binary if build.universal?

    if build.head?
      cd "DevIL"
      system "./autogen.sh"
    end

    # GCC 5 build failure: https://github.com/Homebrew/legacy-homebrew/issues/40442
    # Reported 4th May 2016: https://github.com/DentonW/DevIL/issues/31
    # Fix is from NetBSD: http://cvsweb.netbsd.org/bsdweb.cgi/pkgsrc/devel/devIL/patches/patch-include_IL_il.h
    inreplace "include/IL/il.h",
      "#ifdef RESTRICT_KEYWORD",
      "#if defined(RESTRICT_KEYWORD) && !defined(__cplusplus)"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ILU
    ]
    args << "--enable-ILUT" if build.stable? || build.with?("ilut")
    args << "--disable-tiff" if build.without? "libtiff"

    # "fatal error: 'IL/ilut.h' file not found"
    # Reported 4th May 2016: https://github.com/DentonW/DevIL/issues/32
    # Fixes the test for HEAD builds that have ILUT disabled
    if build.without? "ilut"
      inreplace "include/IL/devil_cpp_wrapper.hpp",
        "<IL/ilut.h>", "\"ilu.h\""
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <IL/devil_cpp_wrapper.hpp>
      int main() {
        ilImage image;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lIL", "-lILU", "-o", "test"
    system "./test"
  end
end
