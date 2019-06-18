class Cf4ocl < Formula
  desc "C Framework for OpenCL"
  homepage "https://fakenmc.github.io/cf4ocl/"
  url "https://github.com/fakenmc/cf4ocl/archive/v2.1.0.tar.gz"
  sha256 "662c2cc4e035da3e0663be54efaab1c7fedc637955a563a85c332ac195d72cfa"
  revision 1

  bottle do
    cellar :any
    sha256 "bac407173815fb9bed500a83fb8c2cac4c599a4b1c35a6a619adbfa746817162" => :mojave
    sha256 "d5903425babf74b3f3af6b4aebf7e0c583bf0729d15799b4a99208141ca80b5a" => :high_sierra
    sha256 "dfbd0e6e303f7f8ff286e38b98562cbf9b18ac880070fcfa19240b0b9c8d4a2a" => :sierra
  end

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
