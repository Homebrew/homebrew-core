class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20190823.6.tar.gz"
  sha256 "83dd45120e9674319f91e4379013831e124c0858e050bbc3521e3f8aebe5c95b"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "5f5f3e9a71c2b2ba7362ea9f6d725f0a86385ed76faefabe2ce1e8060f40d949" => :catalina
    sha256 "cd9e2218ba5994b9c8d8a03f53f48e4060f5f521edd7c692ff07907deef6fec3" => :mojave
    sha256 "5dfe79e4ec483f78779750ac47405d53e75215d60bb9b326ce0397e14723f048" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on :macos => :high_sierra # C++ 17 is required

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccls", "-index=#{testpath}"
  end
end
