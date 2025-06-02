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
    sha256 cellar: :any,                 arm64_sequoia: "5225bfe7d15357bd7cc7d26d4a958435351e4239e9260d5343e2668f5977d1f8"
    sha256 cellar: :any,                 arm64_sonoma:  "bd0206f7ef7c3f0f0a6582c2a1fa91cc60e79b733568d7b029a57e6037da71af"
    sha256 cellar: :any,                 arm64_ventura: "324a396d02a60943e980cf9b50426eae98c192ca22ca095a48f905e96fa8126d"
    sha256 cellar: :any,                 sonoma:        "dcb1e5a8e88a3e73d6a7fe7bcfc29287f5bfd316707b11885243123a72513098"
    sha256 cellar: :any,                 ventura:       "478a00d6b64bc104d295c5ba17dd1ee2ee4d0abb402156637197bfbd9d89458a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d34a3a27828011996fe3e1eb69930b95e82780d37f0d7228bbbcb75ffb95ff2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cabdc713bdbfcedd5f85a543e9a573b4976cb074ad9ee7556ca0323a23184c6b"
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
