class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://www.exiv2.org/"
  url "https://www.exiv2.org/builds/exiv2-0.27.1-Source.tar.gz"
  sha256 "f125286980fd1bcb28e188c02a93946951c61e10784720be2301b661a65b3081"
  head "https://github.com/Exiv2/exiv2.git"

  bottle do
    cellar :any
    sha256 "57031a4f2db1e2f493eaf70a3633335f568b22bd3a325791d90dc2aba2d89902" => :mojave
    sha256 "3bc7f852d91f4c88e4f23d3926f7097f912af373948fb565f4241605eaec6122" => :high_sierra
    sha256 "e1a838f4ce6aa87f914aac1153a45fcf5e66347f6d2b5f2e3072a3738866a8cf" => :sierra
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
