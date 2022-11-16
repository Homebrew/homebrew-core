class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/releases/download/v0.27.5/exiv2-0.27.5-Source.tar.gz"
  sha256 "35a58618ab236a901ca4928b0ad8b31007ebdc0386d904409d825024e45ea6e2"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url "https://exiv2.org/download.html"
    regex(/href=.*?exiv2[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a0351a235000780baccb6c1ad13868c74c7f66990b70e4fc2c0f8e85ad1bd73b"
    sha256 cellar: :any,                 arm64_monterey: "df5a064e5e5828cab5d4dace6d467c0880168f2cfe4eff96d95805f4ec0a1090"
    sha256 cellar: :any,                 arm64_big_sur:  "3de53aea67fdf1b2e0db0d360d4d594c84cfa6e602207764cf69587bbb08ab98"
    sha256 cellar: :any,                 ventura:        "a243413c30e6d2a8baafb01f9860785e5fc6ce0b91130ffe47062e7b8cc77763"
    sha256 cellar: :any,                 monterey:       "bc67f1f00301efd37e9c4b69fc174260c95016d751757f099426a33515a85a73"
    sha256 cellar: :any,                 big_sur:        "3577a686dde0a3441b0aa655dc176cefd3d6897dfb790458c86ba00f5ed12cb9"
    sha256 cellar: :any,                 catalina:       "78976c980580a1286b077679225902a444dff19a17e392a7d5e2f609f8619f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e727a5c7cac7fcd2238ab707976c8e049394d166dd2e382898a7bd94d66523"
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "libssh"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

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
      -DEXIV2_ENABLE_BMFF=ON
      -DEXIV2_BUILD_SAMPLES=OFF
      -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/#{shared_library("libssh")}
      -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
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
