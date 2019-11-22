class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://www.exiv2.org/"
  url "https://www.exiv2.org/builds/exiv2-0.27.2-Source.tar.gz"
  sha256 "2652f56b912711327baff6dc0c90960818211cf7ab79bb5e1eb59320b78d153f"
  head "https://github.com/Exiv2/exiv2.git"

  bottle do
    cellar :any
    sha256 "fdadbb93ae659a651b2e7b899c3c2bf8910b8f0891661903a04a4c81a66ff534" => :catalina
    sha256 "3b78b8fbffcc6d62685bc4a9a0a51855f5ccf6fe7fabc866f0970e1a12ced0b4" => :mojave
    sha256 "8a4e65d47307247b11127c00cdad18626425eafb271faaeb1c076beb57298e12" => :high_sierra
    sha256 "fe386bc9bfe7270655a6b3163f8e33a6fc6e6f36512e6ac6e6a49a1650a6a485" => :sierra
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
