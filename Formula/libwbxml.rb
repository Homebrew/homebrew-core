class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://sourceforge.net/projects/libwbxml/"
  url "https://downloads.sourceforge.net/project/libwbxml/libwbxml/0.11.6/libwbxml-0.11.6.tar.bz2"
  sha256 "2f5ffe6f59986b34f9032bfbf013e32cabf426e654c160d208a99dc1b6284d29"
  revision 1
  head "https://github.com/libwbxml/libwbxml.git"

  bottle do
    cellar :any
    sha256 "8f29b62739e25768b3a2fd76e975c4121528d01ad5d41bc105a4bf109c52a9dd" => :mojave
    sha256 "fe118d9f756018a53381df94681db25bf2d761b47fde308716bca017b61029ff" => :high_sierra
    sha256 "753215897d0b041e488352e66daa4a807973705bb356fbf52e8c9d5dfbad443e" => :sierra
    sha256 "1b510f8b6def29d207916e63a2b63ca44097e0568d432b2e9525deb2e849cc08" => :el_capitan
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
