class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/archive/refs/tags/v0.28.8.tar.gz"
  sha256 "ea51b0609f58a9afa063b60daa1539948b62247721e154f4fff0ad3aec9f9756"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb8893ed6691191316d9a49d154225d21de757100cba6ee4a4c7085ff42b4265"
    sha256 cellar: :any,                 arm64_sequoia: "e3203c49dce1e55609cd9d5f4d31e6cdf884b705b087082a2a0d8f76b2e4db5b"
    sha256 cellar: :any,                 arm64_sonoma:  "10cccfbeebc55c69140eb1d6649d7011696f349006ccaa05811d51c244067a8e"
    sha256 cellar: :any,                 sonoma:        "f14d137e2dd33f271cfa714f180451f32eb6a7d3f9391b71ae8a374e96e538af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "189b9457b0482eff75f5896e5494649796d576b6b723707360acd328b17b8ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dce70243b7ae3edfb4b097810add3ec263dbec8254bcb1210445728f4af4edd2"
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
