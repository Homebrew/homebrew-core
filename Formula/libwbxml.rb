class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://sourceforge.net/projects/libwbxml/"
  url "https://downloads.sourceforge.net/project/libwbxml/libwbxml/0.11.6/libwbxml-0.11.6.tar.bz2"
  sha256 "2f5ffe6f59986b34f9032bfbf013e32cabf426e654c160d208a99dc1b6284d29"
  head "https://github.com/libwbxml/libwbxml.git"

  bottle do
    cellar :any
    sha256 "d9793123d4fde1307610f37fe64251bd4d92da7bbb531289868867a9b5bc1fdf" => :high_sierra
    sha256 "137d796ea2bcd0263c51d4d92ce96527ce73c23e933d66f226270baa97d1359f" => :sierra
    sha256 "56dd0a5203520961413655ecbc8d60058b639179ac5c704848005a3a5179d78f" => :el_capitan
    sha256 "6d3e97ce2d8a218780186f5be0005682768eb823ed0aec2c2275dabca8caafe3" => :yosemite
  end

  option "with-docs", "Build the documentation with Doxygen and Graphviz"
  option "with-verbose", "Build with verbose logging support"
  deprecated_option "docs" => "with-docs"

  depends_on "cmake" => :build
  depends_on "wget" => :optional

  if build.with? "docs"
    depends_on "doxygen" => :build
    depends_on "graphviz" => :build
  end

  def install
    # Sandbox fix:
    # Install in Cellar & then automatically symlink into top-level Module path.
    inreplace "cmake/CMakeLists.txt", "${CMAKE_ROOT}/Modules/", "#{share}/cmake/Modules"

    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_DOCUMENTATION=ON" if build.with? "docs"
      args << "-DWBXML_LIB_VERBOSE=ON" if build.with? "verbose"
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
