class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.7.0/proj-9.7.0.tar.gz"
  sha256 "65705ecd987b50bf63e15820ce6bd17c042feaabda981249831bd230f6689709"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "3f2a261bb59caa3ee347be881638ddcfc12b9ca17932083875dfe349cdbc9c92"
    sha256 arm64_sequoia: "fca0806f8cd6cb3adda9773905223b8d54953358ab13f3d09e51f2f4cc375b64"
    sha256 arm64_sonoma:  "294eef8e71361edbff6b498ce36836371fb3649b0daa948164aa0fd3f28ff5b2"
    sha256 sonoma:        "2bf1a69543056eba5438bec66b6c5db2b6a72c111242f2d2211e20d2d2a7f468"
    sha256 arm64_linux:   "7e01531f786ca1ddf9ff91a5b272727264ed26488f76cd74e1ce668f3e538169"
    sha256 x86_64_linux:  "b41f77cb6e2425428d1524a43d635e8a7b648196854a4fde4e424a32779a836a"
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
    url "https://github.com/OSGeo/PROJ-data/releases/download/1.23.0/proj-data-1.23.zip"
    mirror "https://download.osgeo.org/proj/proj-data-1.23.zip"
    sha256 "f5cac6342566cfa7481ed6f2be24e1cb2f6d7e17544edb9fc829fca25ddcc4a8"

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
