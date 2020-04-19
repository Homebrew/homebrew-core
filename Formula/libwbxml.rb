class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://github.com/libwbxml/libwbxml"
  url "https://github.com/libwbxml/libwbxml/archive/libwbxml-0.11.7.tar.gz"
  sha256 "35e2cf033066edebc0d96543c0bdde87273359e4f4e59291299d41e103bd6338"
  head "https://github.com/libwbxml/libwbxml.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2c363ea6c4504c817ba8d2c5b5cd8da9e261dff223bb2c0c5356c05013f55a46" => :catalina
    sha256 "90fce3d25a436373feee3fd99b19596c00bab30cdf89303018a111190896aab0" => :mojave
    sha256 "026c871094433f113060870998649acdd8dd8b863a1d21e79e1fd100d45cc287" => :high_sierra
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
