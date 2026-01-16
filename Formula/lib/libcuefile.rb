class Libcuefile < Formula
  desc "Library to work with CUE files"
  homepage "https://www.musepack.net/"
  url "https://files.musepack.net/source/libcuefile_r475.tar.gz"
  version "r475"
  sha256 "b681ca6772b3f64010d24de57361faecf426ee6182f5969fcf29b3f649133fe7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musepack.net/index.php?pg=src"
    regex(/href=.*?libcuefile[._-](r\d+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "1da2975f32e5909cf63724ba5a9479544a0398a7a0d2e958a5ded75262f83799"
    sha256 cellar: :any,                 arm64_sequoia:  "34a5359939dfb84fbbfff58f7ddfc220c7dde287dcda457facbd29e8fe91f0de"
    sha256 cellar: :any,                 arm64_sonoma:   "fe51d6a9722425e0e85648a22805f4f74d800bc97083d44c290075f6fdd0655b"
    sha256 cellar: :any,                 arm64_ventura:  "9329d1062814c86b9e6f85060654e962c06b4de6359756f6cdea2842c4280dc5"
    sha256 cellar: :any,                 arm64_monterey: "5c3e4f0219de1b452bdb4e6684a6a71520d6fe2ba6634d6c2a740d062110a292"
    sha256 cellar: :any,                 arm64_big_sur:  "2d73e0ee1f734eb35034383fa5e0697ace0684f0a1586832613227a6769b07d6"
    sha256 cellar: :any,                 sonoma:         "3e4c6861199211e904b725e50a8a03b4f0592ee5c01355f7ae2190dce3370522"
    sha256 cellar: :any,                 ventura:        "716c579255d43e25cc737a655a136a966cfed604e97497547d949e052b961db5"
    sha256 cellar: :any,                 monterey:       "06a8a88fee28e5288aa1219f8bc5eb1b6f0a3d153dcb250d453d008dd98cbeab"
    sha256 cellar: :any,                 big_sur:        "2d4ea14db508f6439073daa64338f884249c7479af688ec91e4a286a3c42591e"
    sha256 cellar: :any,                 catalina:       "3069cf9b0261d8cedee8979348227f5c77a5c6dcb8942f9fbea20b3e3f190374"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dd236ed5afb1c8db194b07b9c36560b0f03871415f79244c431322f8aea62cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a8324a43e9b1e4782de409dacf6f82de5fa7b955ff871d2d10e56b2dd1324bb"
  end

  depends_on "cmake" => :build

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    # Fix build with CMake 4.0+.
    inreplace "CMakeLists.txt",
              "CMAKE_MINIMUM_REQUIRED(VERSION 2.4)",
              "CMAKE_MINIMUM_REQUIRED(VERSION 3.10)"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install "include/cuetools/"
  end
end
