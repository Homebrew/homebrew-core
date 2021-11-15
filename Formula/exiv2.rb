class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://www.exiv2.org/"
  url "https://www.exiv2.org/builds/exiv2-0.27.5-Source.tar.gz"
  sha256 "35a58618ab236a901ca4928b0ad8b31007ebdc0386d904409d825024e45ea6e2"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git"

  livecheck do
    url "https://www.exiv2.org/builds/"
    regex(/href=.*?exiv2[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5154d667d5a85b3ae16e7b7ba5b542f58db18dcd3c8ffd0186824e7ad3734fe7"
    sha256 cellar: :any,                 arm64_big_sur:  "08ecb10e2ccb420a0085f02c7b9ae2f68a3a051df143794416f212d47a752768"
    sha256 cellar: :any,                 monterey:       "8a2abceaf1f395ec5f8c99f17b3c51f3131e23d9d7ec767c254222c74cc947e6"
    sha256 cellar: :any,                 big_sur:        "295f349b27fbbd1d2336ed4576934ca6066624691b0ab615b4bcaaf31c9b0eb1"
    sha256 cellar: :any,                 catalina:       "d527846d027df10a5aef6d1dfee4f909dc1cdd33058325d6c7be5cd24b5f7ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "803e01203d880519740c22f7ad437c85ecd292c446131e24ce77fa9cb333bdf9"
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
