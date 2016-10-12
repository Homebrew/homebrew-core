class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.6.0/gammaray-2.6.0.tar.gz"
  sha256 "6fe8e0bf9f9a479b7edf7d15e6ed48ad3cca666e149bc26e8fea54c12ded9039"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "2866b5ac18b0dc7da33e960ea2cc0cf4dd4c3bdb41099ebd1d9bddd1cd580c25" => :sierra
    sha256 "be67c233328f3ceb3c78cab631a8ce8af2a1f73298b2f49e35efc30c1806bb12" => :el_capitan
    sha256 "f8b8acae0170846d48f4eda3aa34e40eee95fd120fd12b50d465a1b0c4701ea7" => :yosemite
  end

  option "with-vtk", "Build with VTK-with-Qt support, for object 3D visualizer"
  option "with-test", "Verify the build with `make test`"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "qt5"
  depends_on "graphviz" => :recommended

  # VTK needs to have Qt support, and it needs to match GammaRay's
  depends_on "homebrew/science/vtk" => [:optional, "with-qt5"]

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
