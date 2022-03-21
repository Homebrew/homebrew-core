class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.0.0/proj-9.0.0.tar.gz"
  sha256 "0620aa01b812de00b54d6c23e7c5cc843ae2cd129b24fabe411800302172b989"
  license "MIT"
  revision 1
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "58ce84c1dc63d800c94e58067d9f2d7301f452bd8134fe791db78fc00c2615c0"
    sha256 arm64_big_sur:  "98c31d3b575a377f35d5885929f4cb61f7d21095779b5625f20c7f55adf0e124"
    sha256 monterey:       "315d797132bb902a916fd1e9eb57ca7850139146ab9ae4a758f97ef7bfabe508"
    sha256 big_sur:        "0e064f7d05a6ca33a0dd143962d50e2d16b637683a60e55e632a4e3bfc011937"
    sha256 catalina:       "9d75b4764248ff7603addf35ae66c93c36231b3915def05e2851d6b296d698f0"
    sha256 x86_64_linux:   "8adc516f2ac3b02e6f8f78a4776b698606276111f0fec2568dd0f125071d6b15"
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
  resource "datumgrid" do
    url "https://download.osgeo.org/proj/proj-datumgrid-1.8.zip"
    sha256 "b9838ae7e5f27ee732fb0bfed618f85b36e8bb56d7afb287d506338e9f33861e"
  end

  def install
    (buildpath/"nad").install resource("datumgrid")
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install Dir["static/lib/*.a"]
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
