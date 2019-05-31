class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20190314.1.tar.gz"
  sha256 "01156767c071b530a1ebaa8334541981bcb565c050949b26266d17bfd2214e57"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "50fd5ee04cb89736daeb88f132a83cee8805879d428e496fe6f85f4b967ff5a0" => :mojave
    sha256 "623056f2d98b201e6f73d876e5d7f6c342dc674e963a4be2f6625bb746349885" => :high_sierra
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
