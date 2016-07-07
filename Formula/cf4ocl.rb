class Cf4ocl < Formula
  desc "C Framework for OpenCL"
  homepage "https://fakenmc.github.io/cf4ocl/"
  url "https://github.com/fakenmc/cf4ocl/archive/v2.1.0.tar.gz"
  sha256 "662c2cc4e035da3e0663be54efaab1c7fedc637955a563a85c332ac195d72cfa"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccl_devinfo"
  end
end
