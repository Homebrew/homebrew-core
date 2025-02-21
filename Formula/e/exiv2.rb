class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/archive/refs/tags/v0.28.5.tar.gz"
  sha256 "e1671f744e379a87ba0c984617406fdf8c0ad0c594e5122f525b2fb7c28d394d"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "67453fd4287cb90da83fd03489357cda4ec07aa779a5ceb5a3c2bb4c67088dcf"
    sha256 cellar: :any,                 arm64_sonoma:  "928454e2274e05cf1d0c79d41212899e8af8905e05f24f1e85d85cba5bc1d437"
    sha256 cellar: :any,                 arm64_ventura: "7227b9d4ea7570b1a6a5408cac19728bc1b94bd6622e61b8b44b795ff5cc2cdc"
    sha256 cellar: :any,                 sonoma:        "edbebf507efe7bf0558373b5e2ea77b6cac2a6e74fdfb830419220f7db6fd8cc"
    sha256 cellar: :any,                 ventura:       "6c9fc3cdaee5b0bc97a83eb8895c53c02944b60d50b90e001b89c123b6c54d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b27e53e9a52c29211ad3f3a499cad8e32c8960af25193e61a1f890c3ffa043dc"
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
