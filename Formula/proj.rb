class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.0.1/proj-9.0.1.tar.gz"
  sha256 "737eaacbe7906d0d6ff43f0d9ebedc5c734cccc9e6b8d7beefdec3ab22d9a6a3"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "8c4301de72f3d6e0706711196b1870a9b95554edce4c2e4defb46c309f8dcbdb"
    sha256 arm64_big_sur:  "b5c1ccf9cc88e87594b6fb2cd3a23dce86b2a6e41011032d6ffd2e6422c624da"
    sha256 monterey:       "6b0fc38c196c5cd32acc94a2b7092d56547f9515fcede56553081b0fb5232ed5"
    sha256 big_sur:        "8cf517b1a686968b7d29b39b154c856a3a1aa9c6164d4031469e7168f245053d"
    sha256 catalina:       "53e3acc54f9c9a5a25a90fc248b568cac4d622bc0fabdbd4908efd800b2325fa"
    sha256 x86_64_linux:   "a81bbc9e93aa641b0bf30094af3ba85ef066394b6c2d25192d9cc3b61e92134e"
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
