class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/archive/refs/tags/v0.28.7.tar.gz"
  sha256 "5e292b02614dbc0cee40fe1116db2f42f63ef6b2ba430c77b614e17b8d61a638"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "aff08c1f30eda5208eb797a28238026813df658a4830e9e2b95ab32333628c20"
    sha256 cellar: :any,                 arm64_sequoia: "50d6bf55ab060290299502ebc58d92d382a04000ad0d2bfe6e2f2e45621d2d3b"
    sha256 cellar: :any,                 arm64_sonoma:  "7f7fc05fcec0eee47505ad62eb759376937ea3720c1d32eaaa5287ae44cc18b4"
    sha256 cellar: :any,                 sonoma:        "93837fc48d5ea4e6b10e59cfc5e2026b013c84e9558871abc51c2ffbd6b72d3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86b452e488a4d74d6e4c0cb4d6503b8bb01e24f1e102a5797d38035644dbe377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b92f813973165479b40d6baa57fd16710ddc89e36a84d249ec82b0f226d6a9"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for msgmerge
  depends_on "brotli"
  depends_on "inih"
  depends_on "libssh"

  uses_from_macos "curl"
  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
