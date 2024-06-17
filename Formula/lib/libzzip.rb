class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/refs/tags/v0.13.76.tar.gz"
  sha256 "08b0e300126329c928a41b6d68e397379fad02469e34a0855d361929968ea4c0"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "15f19dfc7c6a73f8f4bb04aa127c4500ac7a1af55e813bf86ba3364622070aba"
    sha256 cellar: :any,                 arm64_ventura:  "221e20d0b735c16d11db541ec21224fc19f356d541add17ff9b4d8e61bbdaee4"
    sha256 cellar: :any,                 arm64_monterey: "c76d32ca1d0a4bd11006d4368ea457a31697011a30b21a281f5920fe3393ab35"
    sha256 cellar: :any,                 sonoma:         "3d4f73f80d10275b203822a3f494175de5f64fd43a077fbe69fe5113f1b9996a"
    sha256 cellar: :any,                 ventura:        "ee913220cd2c770d2f8c15ec827503eb954bc815c1658756b2d3ef498c9864c4"
    sha256 cellar: :any,                 monterey:       "e8d1a4366fe42a32c95800cfb023d5bc3ca5a275529cf219a03362b3c692ce2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e75ee3d1af8143d33e2b161bdae6d09b256ee8661d2f352f0b4fd40873f9de15"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "zip" => :test
  uses_from_macos "zlib"

  def install
    args = %W[
      -DZZIPTEST=OFF
      -DZZIPSDL=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
