class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20190314.1.tar.gz"
  sha256 "01156767c071b530a1ebaa8334541981bcb565c050949b26266d17bfd2214e57"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "d72512c7435985c15755c6a2dab68ce8032ca6e2372df722a3df38042b121323" => :mojave
    sha256 "5868f7f9e0b17c9ea43ef4658053c8b4dec82442f7736114c8c4019ba168386c" => :high_sierra
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
