class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20190823.5.tar.gz"
  sha256 "6f39fa5ce79c1682973811ce2409718710bfef6008f94f96277393e6846bd76c"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "6e30b69435dab3605ba91fe1fc72835e48aa0818fab5a048f7fd25f174625c30" => :catalina
    sha256 "a419fecb5bf96d334e79eccd23ebf2aa479587f1599496934afa9c08d1679ec3" => :mojave
    sha256 "eb47960da3d60d8ac4bc5982a407f2f1e12e873dcc91b26dd06f0d5fcfa46da8" => :high_sierra
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
