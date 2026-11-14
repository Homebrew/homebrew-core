class Msdfgen < Formula
  desc "Multi-channel signed distance field generator"
  homepage "https://github.com/Chlumsky/msdfgen"
  url "https://github.com/Chlumsky/msdfgen/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "ad381b09ef61af235690ea96eefafd01fd35f5163bcb6ad73db7904997675b71"
  license "MIT"
  compatibility_version 1
  head "https://github.com/Chlumsky/msdfgen.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1e062d0c6f7a4cfb50ebee6ef8488324b5b889ac260129e2fd299ac1777aa0c2"
    sha256 cellar: :any, arm64_tahoe:       "e4e81ae6c9cc6e617d568268e02fc975c264d57385049f54e0cd971d7c6ad9a7"
    sha256 cellar: :any, arm64_sequoia:     "09e4e0f299d7f11bdd9d460d898ee3df043547209ec820c283299df4479be913"
    sha256 cellar: :any, arm64_linux:       "67a1b8bee4924298f5cbd6ea4e6c89ecaef0b1a26490181e6a809c1d85595a84"
    sha256 cellar: :any, x86_64_linux:      "777bd9b56964995e56fcdc4dc4186fbe792126350d67a011a9cb57074c8c9832"
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "tinyxml2"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DMSDFGEN_USE_VCPKG=OFF",
           "-DMSDFGEN_USE_SKIA=OFF",
           "-DMSDFGEN_INSTALL=ON",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"msdfgen", "msdf",
           "-defineshape", "{ -1, -1; m; -1, +1; y; +1, +1; m; +1, -1; y; # }",
           "-o", "out.png", "-size", "32", "32"
    assert_path_exists testpath/"out.png"
  end
end
