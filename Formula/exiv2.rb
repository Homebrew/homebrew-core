class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://www.exiv2.org/"
  url "https://www.exiv2.org/builds/exiv2-0.27.1-Source.tar.gz"
  sha256 "f125286980fd1bcb28e188c02a93946951c61e10784720be2301b661a65b3081"
  revision 1
  head "https://github.com/Exiv2/exiv2.git"

  bottle do
    cellar :any
    sha256 "7be6ba25f15d9eb371cba00aa26cd977fea27a1546b2ea8de96bc3945644b4fa" => :mojave
    sha256 "0b4bf9fdcf3fd6ab4be92927bf8392fb46197d6f2904b427afcf924ad687b28a" => :high_sierra
    sha256 "ca267d764864eb6858cd22c9614ea85df84b2fc801cc696681a5757e7df9f335" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "libssh"

  def install
    args = std_cmake_args
    args += %W[
      -DEXIV2_ENABLE_XMP=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_PNG=ON
      -DEXIV2_ENABLE_NLS=ON
      -DEXIV2_ENABLE_PRINTUCS2=ON
      -DEXIV2_ENABLE_LENSDATA=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_WEBREADY=ON
      -DEXIV2_ENABLE_CURL=ON
      -DEXIV2_ENABLE_SSH=ON
      -DEXIV2_BUILD_SAMPLES=OFF
      -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/libssh.dylib
      -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
      ..
    ]
    mkdir "build.cmake" do
      system "cmake", "-G", "Unix Makefiles", ".", *args
      system "make", "install"
    end
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
