class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://github.com/libwbxml/libwbxml"
  url "https://github.com/libwbxml/libwbxml/archive/libwbxml-0.11.7.tar.gz"
  sha256 "35e2cf033066edebc0d96543c0bdde87273359e4f4e59291299d41e103bd6338"
  head "https://github.com/libwbxml/libwbxml.git"

  bottle do
    cellar :any
    sha256 "4adbd8447466f7d3cbad72d5aff2730a87539dacd0638180cd39a9eaee11e174" => :catalina
    sha256 "9077d1c9669a92c39590de8280678cbe3d50853e76d69fda6a476ba88d170845" => :mojave
    sha256 "051a666b16d73e92e4910f40559d2bb5681ae4b5028a7f86959ad5f6bdb4e55a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "wget"

  def install
    # Sandbox fix:
    # Install in Cellar & then automatically symlink into top-level Module path
    inreplace "cmake/CMakeLists.txt", "${CMAKE_ROOT}/Modules/",
                                      "#{share}/cmake/Modules"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_DOCUMENTATION=ON"
      system "make", "install"
    end
  end
end
