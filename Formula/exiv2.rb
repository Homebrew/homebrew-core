class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "http://www.exiv2.org/"
  url "http://www.exiv2.org/builds/exiv2-0.27.0a-Source.tar.gz"
  sha256 "a4adfa7aaf295b0383adead476f8e0493b9d6c6c7570d5884d2ebf8a2871902f"
  head "https://github.com/Exiv2/exiv2.git"

  bottle do
    cellar :any
    sha256 "0d55621ba183fee1850242a07fd5cd78622daff82f9a4877a4c1aa14e114cbf7" => :mojave
    sha256 "36d48ac8ec05df9ae69d35561d14dde24e5a6b31e44fae3235d648c62bb9abfc" => :high_sierra
    sha256 "5c0229876d4183240896b8d31347adf99c90ff45b8d3dd45ec5d13bdd83c1e2b" => :sierra
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
