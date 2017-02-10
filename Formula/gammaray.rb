class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  revision 2
  head "https://github.com/KDAB/GammaRay.git"

  stable do
    url "https://github.com/KDAB/GammaRay/releases/download/v2.6.0/gammaray-2.6.0.tar.gz"
    sha256 "6fe8e0bf9f9a479b7edf7d15e6ed48ad3cca666e149bc26e8fea54c12ded9039"

    # Upstream commit from 23 Jan 2017 "Fix macOS startup crash with Qt 5.8"
    patch do
      url "https://github.com/KDAB/GammaRay/commit/01c5154.patch"
      sha256 "c4d44f2625fa3823e0c6788437446247473cc460877be87a5e33d2b1b1a9d6ff"
    end
  end

  bottle do
    sha256 "40abbbf3706bcd8671fae35f7e53397b090895d9022e7f1dc1370d572342a87a" => :sierra
    sha256 "b289c07b23b494f2d9442e77dedfda8227982cdf184e938cbc248454db85b272" => :el_capitan
    sha256 "3c4094ed9c841a17de8a87f696f038c99f1e532bd3de13664068cb7bc5ab623a" => :yosemite
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
