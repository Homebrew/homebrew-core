class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.7.1/proj-9.7.1.tar.gz"
  sha256 "6c097dc803c561929cdfcc46e4bf9945ea977611fb31493ad14e88edaeae260f"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "186e8a99b38e9c60591293934c53d97c9ff69d996267b2b908a068496c5fed98"
    sha256 arm64_sequoia: "8855329696395f10f20a395e9901cb40dc1726b6ac19bc5267405933356fdde9"
    sha256 arm64_sonoma:  "4f07764a84e344b5a6d5e7a77012b219eb61aefff835ad22fe53ec0f3a08c226"
    sha256 sonoma:        "cdd1380c4b5f82018211aab61a0f4d4a185ce5d0ad80c240f0d28fc06bdbc520"
    sha256 arm64_linux:   "fc43c2f4c3b50bf8b139f5c5e849aa67a66dcaedc7184f6a9781ada31050ee37"
    sha256 x86_64_linux:  "06541b7a560f13eb2aaa2f5478e3b8f82c5b1f605f0cef1e445a273a38efac1f"
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
