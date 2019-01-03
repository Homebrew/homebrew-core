class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "http://www.exiv2.org/"
  url "http://www.exiv2.org/builds/exiv2-0.27.0a-Source.tar.gz"
  sha256 "a4adfa7aaf295b0383adead476f8e0493b9d6c6c7570d5884d2ebf8a2871902f"
  head "https://github.com/Exiv2/exiv2.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6499dd1ef18e797aa8f54f1cecd973007c7bf75f3fcc783dd408a6b091f989f0" => :mojave
    sha256 "5b7833350aac57127e8cb770b3c310503d43f03f4ecccdbdfda17132dbd201d1" => :high_sierra
    sha256 "c651fe47fec9f541d47d2dd769cf94d4063baeff2b08be2b8c1056d6609499fc" => :sierra
    sha256 "9f5f339b761aca8910ee859e6630e9eb3f84a7298c029b98baf801f36075ab51" => :el_capitan
    sha256 "1d14797afa32ff75b50ff2737baa8ac27ab7bf90da38359a9721f7e15c398481" => :yosemite
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
