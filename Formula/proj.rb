class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.2.0/proj-9.2.0.tar.gz"
  sha256 "dea816f5aa732ae6b2ee3977b9bdb28b1d848cf56a1aad8faf6708b89f0ed50e"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "b8bda6c6df144eab4b7f8240da2eab263368b736c79e2cac9412cb0021a17da5"
    sha256 arm64_monterey: "10413961f58a8f1403c75eedc0866cae7038985df89ad8180b176e6a33e2cb1b"
    sha256 arm64_big_sur:  "4e59238791d459604f4900722de97e138b4ca6b85f45a1f29c52f30a62261060"
    sha256 ventura:        "679b24c831253da61787a251be04438e268916edbce18e91411845ee05b003f2"
    sha256 monterey:       "cf4be54fadf8f7d807562cd3dcab8668104afa9c656fb77eaff2deec0b3dbffe"
    sha256 big_sur:        "d6ba29403239a36dc10ea20737cff918e304cada1f893b7a3edc9819794c00f4"
    sha256 x86_64_linux:   "448c7cacb51fa79ac7b3eed95b45a1541833b7963b9ae4ce45595e9d77e732aa"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libtiff"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  conflicts_with "blast", because: "both install a `libproj.a` library"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "proj-data" do
    url "https://download.osgeo.org/proj/proj-data-1.13.tar.gz"
    sha256 "f1e5e42ba15426d01d1970be727af77ac9b88c472215497a5a433d0a16dd105b"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install Dir["static/lib/*.a"]
    resource("proj-data").stage do
      cp_r Dir["*"], pkgshare
    end
  end

  test do
    (testpath/"test").write <<~EOS
      45d15n 71d07w Boston, United States
      40d40n 73d58w New York, United States
      48d51n 2d20e Paris, France
      51d30n 7'w London, England
    EOS
    match = <<~EOS
      -4887590.49\t7317961.48 Boston, United States
      -5542524.55\t6982689.05 New York, United States
      171224.94\t5415352.81 Paris, France
      -8101.66\t5707500.23 London, England
    EOS

    output = shell_output("#{bin}/proj +proj=poly +ellps=clrk66 -r #{testpath}/test")
    assert_equal match, output
  end
end
