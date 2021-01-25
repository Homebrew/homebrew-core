class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20201219.tar.gz"
  sha256 "edd3435bc7e55d9e5dc931932f9c98275a6a28d1ab1f66416110e029f3f2882a"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "934fb8fd594d6e7adbfa14b5608f1de14309db34f2cf61a0cb572bdc772b2aa3" => :big_sur
    sha256 "d5ca1cea0c9263669a001abf5924d77020358e6bef09d49516a08475f9646632" => :arm64_big_sur
    sha256 "86c44f95a0426b030db7487e50e1fdcab8bdb86983885b4efa7926417888729b" => :catalina
    sha256 "922241ccaa6870b1b472d3a080824ec5e0b0dff2403b796b3f101856ea0d350c" => :mojave
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
