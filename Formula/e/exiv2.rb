class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/releases/download/v0.27.6/exiv2-0.27.6-Source.tar.gz"
  sha256 "4c192483a1125dc59a3d70b30d30d32edace9e14adf52802d2f853abf72db8a6"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url "https://exiv2.org/download.html"
    regex(/href=.*?exiv2[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8bf182b90d97afa7440cd1614a51b48c6a1a3b43ac7d5c4ac6013ab80fb1137"
    sha256 cellar: :any,                 arm64_monterey: "333f89f2cf93031046718a29a228050d431272e818fe1d89687c3e1981b23884"
    sha256 cellar: :any,                 arm64_big_sur:  "151aeb245e05e2e0a8f46da4979d0233a5820aea34e22fe191913f5499c259db"
    sha256 cellar: :any,                 ventura:        "22a09bf8a504f1ec3c19c4e7e52c47615c37412a8acdd4ec13dddac767f54b79"
    sha256 cellar: :any,                 monterey:       "80c73e17a8d67741cf13b02959f1fcbe09c64126c469c465a8fa101907c22b9c"
    sha256 cellar: :any,                 big_sur:        "878bfea27f1f04e01bbeca7203f26a7732cece76cfebf6d1a2b6a71fade9d13b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7613f59e7848995120cf631b90509f45628195a9c18882464594a791f311dd2"
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
