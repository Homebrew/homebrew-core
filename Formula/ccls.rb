class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20201219.tar.gz"
  sha256 "edd3435bc7e55d9e5dc931932f9c98275a6a28d1ab1f66416110e029f3f2882a"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "aef6e8248dda65a8c4ec322e46c2c96ccdfa3d3086e2f96353f0a5fdca6cc739" => :big_sur
    sha256 "9eeac4bcb801299d73e1d8a838b9b75701cef86506928082c5b63603949fad4e" => :catalina
    sha256 "eb2e73b77b5c3221fe9bc2b3330b9a2456b95558fc3b326fc29d35739467847d" => :mojave
    sha256 "578e24f878766fdcc3e024ddfcd6d124fbeaa79c79e32b89f6286f58d1213894" => :high_sierra
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
