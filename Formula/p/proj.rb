class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.5.1/proj-9.5.1.tar.gz"
  sha256 "a8395f9696338ffd46b0feb603edbb730fad6746fba77753c77f7f997345e3d3"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "c45845ace46c4164cb83ba2830526e995c45b7186810ff6ede827f5aff19754f"
    sha256 arm64_sonoma:  "3c982d2d1e098fd1af5c933f3b3e858a934a4d4ed4a13ddff2f6bbdc0f19c4ea"
    sha256 arm64_ventura: "38a0b4d4eb667cf12f3ff7e35caec9eeae3b052b9ebbd808d18136374eac7b03"
    sha256 sonoma:        "30eb5c830c5d0f7aa4660102dcee7abfe66bcc4accb9d8a3ba4906b10ca635d5"
    sha256 ventura:       "9230636c4187be1b0e923ca3f356411e1b27cc7e5a716debc22eca232569b69b"
    sha256 x86_64_linux:  "6fe61c5481a8f5a8b53d97120c62260fbe74db4e8c969ffb10e241a98d0a7779"
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
    url "https://download.osgeo.org/proj/proj-data-1.20.zip"
    sha256 "a83c6dc5e98350c9c78d5029c8e211db1598ff01b1f6db18e4c21cc25dcf2165"
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
