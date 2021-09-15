class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://www.exiv2.org/"
  url "https://www.exiv2.org/builds/exiv2-0.27.4-Source.tar.gz"
  sha256 "84366dba7c162af9a7603bcd6c16f40fe0e9af294ba2fd2f66ffffb9fbec904e"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git"

  livecheck do
    url "https://www.exiv2.org/builds/"
    regex(/href=.*?exiv2[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2bde081b463a93a9672b7a842c9e37c55795643077b8b71b06b77381579cb8e4"
    sha256 cellar: :any,                 big_sur:       "2142d3d9ac41a438aec051a364d76458a7e3be1e2b5b9aa5568f56094ed8b928"
    sha256 cellar: :any,                 catalina:      "b07c163f12af0b32df8f5cf728bf8751312c9f04962df2c2cb00b4b13f9ef8da"
    sha256 cellar: :any,                 mojave:        "97f623c1b9562b8e39354829c59b766c2c964234899c60e8a982c90c915d59dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfba79e0025add90a988ca5343c1cd91e8f525ee223de719394cbcef1c140f21"
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
