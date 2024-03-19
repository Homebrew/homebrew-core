class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "543bead934135f20f438e0b6d8858c55c5fcb7ff80f5d1d55489965f1aad58b9"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca780563ba656cfc99b0ed142f06d54d26c1ece6d7c6f8e51a4e82163afd3acb"
    sha256 cellar: :any,                 arm64_ventura:  "9282cad50a3a70ae91e50c67a553745a3e6a8660bb59d258d6c9310eee540124"
    sha256 cellar: :any,                 arm64_monterey: "99c6f4a05e07799254abbc5b8d86cf680ce0c50f9bc6610491641a16a9f29c3f"
    sha256 cellar: :any,                 sonoma:         "57d8bdc1c1e4af2f00038a4493c6ed2d65997c6a736e9748c4cc0cca7c2df148"
    sha256 cellar: :any,                 ventura:        "ab4457297c5b7b439867aec8cf85278ccd98a3fa893b1f898c923ca6dbdc3d35"
    sha256 cellar: :any,                 monterey:       "8addc4911d8cac340c27b3837ebd618b96888b622f9cbcb35a9e453485652f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5be1cbbf90f04a517dbdb9e8499a877c98714eb3c9da5945c2bead7f87005aae"
  end

  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "gettext"
  depends_on "inih"
  depends_on "libssh"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    args = %W[
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

    system "cmake", "-G", "Unix Makefiles", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
