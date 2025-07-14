class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.6.2/proj-9.6.2.tar.gz"
  sha256 "53d0cafaee3bb2390264a38668ed31d90787de05e71378ad7a8f35bb34c575d1"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "37fc9f7eabdc4118117d07a91fca5fbc883600f545e3ce46e74f7c14af00b9c0"
    sha256 arm64_sonoma:  "15f554ed65e9e9ab8a9c7a0e3d777bf21a56d6fcc753c361e7d680c87eb3855d"
    sha256 arm64_ventura: "7b991b91425fa3c3e9c0f0e381e5f8f174e514691c2906edac3eaadc112e0ad8"
    sha256 sonoma:        "517adcf737dbd18c98f4786ea7b49ccd24df57c3f312c848d66bb420b790ff04"
    sha256 ventura:       "2304f2bdd4ce624f41cc84d26f76a015711c98a78b8ee5341e9604351771f7d8"
    sha256 arm64_linux:   "bf431c655f9c9a09fd036dfb7c1d453899d37e2a40bd2aab0e1c301aca5f27f4"
    sha256 x86_64_linux:  "e9fb5dcd6d7955c814fdc170a64782f37f6855e4187984ab41d160f8dc22417f"
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
    url "https://download.osgeo.org/proj/proj-data-1.22.zip"
    sha256 "ebca54b7f9118beafd30a5abeaeacfee6be9f59a0bb52419c9282cf34ee2510a"

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
