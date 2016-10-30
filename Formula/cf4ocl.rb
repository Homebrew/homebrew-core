class Cf4ocl < Formula
  desc "C Framework for OpenCL"
  homepage "https://fakenmc.github.io/cf4ocl/"
  url "https://github.com/fakenmc/cf4ocl/archive/v2.1.0.tar.gz"
  sha256 "662c2cc4e035da3e0663be54efaab1c7fedc637955a563a85c332ac195d72cfa"

  bottle do
    cellar :any
    sha256 "5dbbea6e4ea10e6087b197c4779c6907229a9e44639b3c4672f46a8e0bf6ccc8" => :sierra
    sha256 "b8846c70badd3c21ce06a77b4693b86a4c95b7010da10a8aa219957b63d45862" => :el_capitan
    sha256 "996ae5013abe7b7cd028425e3a4d8a27aef854a1a4f086480b3626b83f629b99" => :yosemite
    sha256 "fdb0ae96786ea4b8079b0dadad53a9f497b754f52c312958fa09523aa3a0e856" => :mavericks
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
