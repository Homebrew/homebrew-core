class Msdfgen < Formula
  desc "Multi-channel signed distance field generator"
  homepage "https://github.com/Chlumsky/msdfgen"
  url "https://github.com/Chlumsky/msdfgen/archive/refs/tags/v1.13.tar.gz"
  sha256 "93cd1ad8918c1a78c5c96e82d4f4c77f0eb86c2e7e8579a0967e54196c4b7167"
  license "MIT"
  head "https://github.com/Chlumsky/msdfgen.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d035596570fd1be46d3479bf5de7ce23384810298a0fe8124b695eec1d639d2e"
    sha256 cellar: :any, arm64_sequoia: "dc56c5e609f387e28efa0eac84c13670b4f6cb6c3ec4b09655053cec315b9c7e"
    sha256 cellar: :any, arm64_sonoma:  "90005d7e93f45792c82ed28c74a3c8386b18a574973691e877f2f97cbb0ac129"
    sha256 cellar: :any, sonoma:        "c6178719aeb5131fd0a9837de68c5ec3e88ebfa81b3c16046f5b988d93de99ba"
    sha256 cellar: :any, arm64_linux:   "a5be6c4953bdbf5f72e9ebf47c8b739e1587b3fbaa609a6c009545905655e2fb"
    sha256 cellar: :any, x86_64_linux:  "eab7df1301d127cb14743010b4e7843172c5d9b197a6b00a8e227a2e155e1818"
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "tinyxml2"

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
