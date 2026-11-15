class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/archive/refs/tags/v0.28.9.tar.gz"
  sha256 "700b76b97695b2fab4ef8c79619c68ae57d09e0c130724791cafbd39e0eb4aef"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c3297dda61a63550426afc5948420942e05888db68edb149fb37b76f32dc0648"
    sha256 cellar: :any, arm64_tahoe:       "1bf5ecd63412646a9969cb43b8422d0e5fb2f20518f4486b7f2e96d771ef084d"
    sha256 cellar: :any, arm64_sequoia:     "7c4b3ae3eff4a717473f7d465dacea8bfce5c6c4a947da4c1755c7ccaa633515"
    sha256 cellar: :any, arm64_sonoma:      "4d61927c3d35cceef91f1be2812537a33464323900edea98cb8b1e171d4ef6f9"
    sha256 cellar: :any, arm64_linux:       "70ea1747fa415034e2e6e91e3afb96ab0f15746bf92a106bec81006a909793cb"
    sha256 cellar: :any, x86_64_linux:      "17da282eab8ac3881a9ba74b359593a0e11ade982bd0f8075c852f3c9bea4b3c"
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
      -DSSH_LIBRARY=#{formula_opt_lib("libssh")}/#{shared_library("libssh")}
      -DSSH_INCLUDE_DIR=#{formula_opt_include("libssh")}
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
