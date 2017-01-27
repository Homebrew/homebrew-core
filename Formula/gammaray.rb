class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.6.0/gammaray-2.6.0.tar.gz"
  sha256 "6fe8e0bf9f9a479b7edf7d15e6ed48ad3cca666e149bc26e8fea54c12ded9039"
  revision 1
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "342fc389969f8cbf452757845f6479d23dcc569bfbaadcde4390451e0126510e" => :sierra
    sha256 "f85cc86e12cf89563063771b31bedc20995840594730ca6eca4c6bc055c96818" => :el_capitan
    sha256 "dd95dae687e38ec2b9f73a24f8a60a16a6c7edded1cc9e1e3f75a9341582e95b" => :yosemite
  end

  option "with-vtk", "Build with VTK-with-Qt support, for object 3D visualizer"
  option "with-test", "Verify the build with `make test`"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "qt@5.7"
  depends_on "graphviz" => :recommended

  # VTK needs to have Qt support, and it needs to match GammaRay's
  depends_on "homebrew/science/vtk" => [:optional, "with-qt@5.7"]

  def install
    # For Mountain Lion
    ENV.libcxx

    # attachtest-lldb causes "make check" to fail
    # Reported 31 Jul 2016: https://github.com/KDAB/GammaRay/issues/241
    inreplace "tests/CMakeLists.txt", "/gammaray lldb", "/gammaray nosuchfile"

    args = std_cmake_args
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=" + ((build.without? "vtk") ? "ON" : "OFF")
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=" + ((build.without? "graphviz") ? "ON" : "OFF")

    system "cmake", *args
    system "make"
    system "make", "test" if build.bottle? || build.with?("test")
    system "make", "install"
  end

  test do
    (prefix/"GammaRay.app/Contents/MacOS/gammaray").executable?
  end
end
