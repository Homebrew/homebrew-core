class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.0.1/proj-9.0.1.tar.gz"
  sha256 "737eaacbe7906d0d6ff43f0d9ebedc5c734cccc9e6b8d7beefdec3ab22d9a6a3"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "64836f00b9d9e539c50c0f22c8bce44db08440df78809644ce2f47eb8505572b"
    sha256 arm64_big_sur:  "c2ab7936f8f96b36f4281559e6784307fbba06b9d4f096bce714cdf6ffd4511a"
    sha256 monterey:       "d1deff50d533d1f356f2d3e6a7c21d097d9fda80dda5e70e2cee51185f57758b"
    sha256 big_sur:        "2894ec28f61bd5e53c7bff209ab2a3ecb8503561af56eacd3c7043344f0bc439"
    sha256 catalina:       "074a79e855c77dbc9e77949e8f9988f17af555b859be46aef20832152617c388"
    sha256 x86_64_linux:   "1b81757b8d467f46d0a9f93bbbbc72166e54508d39b61db01ad3d07134842f3e"
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
    url "https://download.osgeo.org/proj/proj-data-1.9.zip"
    sha256 "6880bfe2c4f6bc69fec398e9b356f50a05d559a59ab05bd65401bf45f4a4b6da"
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
