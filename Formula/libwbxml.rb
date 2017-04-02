class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://sourceforge.net/projects/libwbxml/"
  url "https://downloads.sourceforge.net/project/libwbxml/libwbxml/0.11.5/libwbxml-0.11.5.tar.bz2"
  sha256 "5f8fabc0152d73b725e16211ccd74263c1c2f9f1dc36a2fd916a8deb4ee577e2"
  head "https://github.com/libwbxml/libwbxml.git"

  bottle do
    cellar :any
    sha256 "ff3988645fd4ed0fab3a44c7ec4d51247bece66319c75563125c85803d8759e3" => :sierra
    sha256 "7e418f10145443f0aa9f0107d44091123230035ae48fe1fc9421bf1bc9ff480f" => :el_capitan
    sha256 "e0d3fef67a6d509a486d06e633df0b6e9cc2c303acb6c7f6146e1cc17b741a84" => :yosemite
  end

  option "with-docs", "Build the documentation with Doxygen and Graphviz"
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
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
