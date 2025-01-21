class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/archive/refs/tags/v0.28.3.tar.gz"
  sha256 "1315e17d454bf4da3cc0edb857b1d2c143670f3485b537d0f946d9ed31d87b70"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a1518a087da74728c1e62876ac3bbad8c5fcbb0b22923112277b2e39b3623a03"
    sha256 cellar: :any,                 arm64_sonoma:   "efb8f139466e2367005371ce2651b1c78b2784ddf42d884b25fc2a05880a0d92"
    sha256 cellar: :any,                 arm64_ventura:  "9339cce8f0f45db0fa6be3d4f80253d1665ff9aba1c72a6e32364e6bcf2232cc"
    sha256 cellar: :any,                 arm64_monterey: "5fdaac94277da85f2fe3546dabcab241043bd21a81e70ca2d23d010a7b231b06"
    sha256 cellar: :any,                 sonoma:         "f905dda4c2efceabd830390a2ad5e97d6c7a059a4b073564ff1347d6ddc56ca5"
    sha256 cellar: :any,                 ventura:        "1bd1c799d30eceaa6920e73f93246db621349186409b4e4a6e0577cf273e05e4"
    sha256 cellar: :any,                 monterey:       "5f4fbc4b711ec127204a8751be6d13219807b527ff059817b92a073576281ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b13959b5dc142dce2c9770abaebaaf3c7de2fa355c388a797f4a480c3d8ea5b5"
  end

  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "inih"
  depends_on "libssh"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build # for msgmerge
  end

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
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
