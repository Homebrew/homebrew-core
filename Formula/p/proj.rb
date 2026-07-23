class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.8.1/proj-9.8.1.tar.gz"
  mirror "https://download.osgeo.org/proj/proj-9.8.1.tar.gz"
  sha256 "af5b731c145c1d13c4e3b4eeb7d167e94e845e440f71e3496b4ed8dae0291960"
  license "MIT"
  compatibility_version 1
  head "https://github.com/OSGeo/proj.git", branch: "master"

  livecheck do
    url "https://download.osgeo.org/proj/"
    regex(/href=.*?proj[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c532d0adc3fdc96268bab9406be54069c26476eb5b8cecb8f748d5df4d1978da"
    sha256 arm64_sequoia: "ec5842c5c5660dccf23487fd8f70e892f91e37107e9feb849b731b3044022cf6"
    sha256 arm64_sonoma:  "628b330cac12775231d22bd1978606e10e47dcb8c53f570901d122e5077f3d90"
    sha256 sonoma:        "9b66a3600a992e790a90dee9baa9e6cd18ddb35caf6460ad4f59a8e105aa0706"
    sha256 arm64_linux:   "3774b7278555c3d2d39a73f05d08bea617fc08427f62d3a6231dd48764053f4c"
    sha256 x86_64_linux:  "fa40fef6883cfb3b098a98a7630ffe26a131e4b6996291bb8c1b873b4393ea72"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libtiff"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  conflicts_with "blast", because: "both install a `libproj.a` library"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "proj-data" do
    url "https://github.com/OSGeo/PROJ-data/releases/download/1.24.0/proj-data-1.24.zip"
    mirror "https://download.osgeo.org/proj/proj-data-1.24.zip"
    sha256 "08617c38078c56ba0df67c760bdf7253141ba5c6749898afe7e779ab14a08271"

    livecheck do
      url "https://download.osgeo.org/proj/"
      regex(/href=.*?proj-data[._-]v?(\d+(?:\.\d+)+)\.zip/i)
    end
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
