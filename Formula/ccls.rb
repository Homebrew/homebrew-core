class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20210330.tar.gz"
  sha256 "28c228f49dfc0f23cb5d581b7de35792648f32c39f4ca35f68ff8c9cb5ce56c2"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 arm64_big_sur: "d5ca1cea0c9263669a001abf5924d77020358e6bef09d49516a08475f9646632"
    sha256 big_sur:       "934fb8fd594d6e7adbfa14b5608f1de14309db34f2cf61a0cb572bdc772b2aa3"
    sha256 catalina:      "86c44f95a0426b030db7487e50e1fdcab8bdb86983885b4efa7926417888729b"
    sha256 mojave:        "922241ccaa6870b1b472d3a080824ec5e0b0dff2403b796b3f101856ea0d350c"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccls", "-index=#{testpath}"
  end
end
