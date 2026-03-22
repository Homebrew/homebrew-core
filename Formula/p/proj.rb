class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.8.0/proj-9.8.0.tar.gz"
  mirror "https://download.osgeo.org/proj/proj-9.8.0.tar.gz"
  sha256 "a8b493b00cf4d08b712b9e063ed5e53e2be90fcde46770e9dbd773341f378f43"
  license "MIT"
  compatibility_version 1
  head "https://github.com/OSGeo/proj.git", branch: "master"

  livecheck do
    url "https://download.osgeo.org/proj/"
    regex(/href=.*?proj[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "defaf305951c06d26473ea55fa96451d530e82a74d0dd11911e6ad53e3acf50f"
    sha256 arm64_sequoia: "489348a45b865ce6a2e2e34de21271251cda77104abfc9c3de65e3a12a4ab69d"
    sha256 arm64_sonoma:  "5a0a7ec12a0ec3086b275be2e8fed4c26ec5cec600ad8b5f885093ae0f0422e9"
    sha256 sonoma:        "f7acf07cc52b72edb0c528cfa0b358f886b572e75d4f03872e4cdeabdb3271ad"
    sha256 arm64_linux:   "b72a50c2b03999df89651807900a18cca8d8b11af76a0d1e026cf9863e99b8f7"
    sha256 x86_64_linux:  "d8425387f472b5c29ce4590aa6af183e21a81c0a4a98d7a55430d28214c31d8e"
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
