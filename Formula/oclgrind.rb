class Oclgrind < Formula
  desc "OpenCL device simulator and debugger"
  homepage "https://github.com/jrprice/Oclgrind"
  url "https://github.com/jrprice/Oclgrind/archive/v16.10.tar.gz"
  sha256 "f2c05ef7e283d9071e07ed6674c199b4b33da44b2e0fdb04d3fd8fe82d388744"

  depends_on "llvm@3.9" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/oclgrind", "ls", "-l"
  end
end
