class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.2.1/proj-9.2.1.tar.gz"
  sha256 "15ebf4afa8744b9e6fccb5d571fc9f338dc3adcf99907d9e62d1af815d4971a1"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "4e765cd5770510556e04ee05b7ec732507f9eb70e382735c23f4cf0f3a094162"
    sha256 arm64_monterey: "5dfad81b135fa02836e2f29a864217f5052799009b3c9fbc28de6de8212d1a2c"
    sha256 arm64_big_sur:  "3cb6336ec473572c590855bb1c42c0fac97e838a7300b3212f9adea8d67781ab"
    sha256 ventura:        "7f40a7b0043ef6490a3c7c0133b71e424fe6f4e8a576d42c9425f08a5df96c69"
    sha256 monterey:       "19a4eca16421c5bb7ba52610de5603e1a05b8dbd598e6876a3e67433d02cf9b4"
    sha256 big_sur:        "3a6cc8421523c7b513b083c0fd9793aa101108ef91575992a7e147bae2d6a0d1"
    sha256 x86_64_linux:   "b0a93d2c51070b22bc9e256955b296d47f2bb10fe690238f88480611f7f5e078"
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
    url "https://download.osgeo.org/proj/proj-data-1.14.tar.gz"
    sha256 "b5fecececed91f4ba59ec5fc5f5834ee491ee9ab8b67bd7bbad4aed5f542b414"
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
