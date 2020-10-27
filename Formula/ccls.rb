class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20190823.6.tar.gz"
  sha256 "83dd45120e9674319f91e4379013831e124c0858e050bbc3521e3f8aebe5c95b"
  license "Apache-2.0"
  revision 1
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "f1215fa22a47c52ea83666f2ebc1c416a39a0b7b80d7f7767e4d049b97e3b8ac" => :catalina
    sha256 "0acf04329f231cd825d4abf3366a7bf5fa26717c4e1421c06b0fef262de1f7ba" => :mojave
    sha256 "b8c9a39e3fc523a5b70f2d25682365ce921761923bd35ac1b41ca4a7f43dce66" => :high_sierra
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
