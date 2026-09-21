class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.9.0/proj-9.9.0.tar.gz"
  mirror "https://download.osgeo.org/proj/proj-9.9.0.tar.gz"
  sha256 "791a0610547eeabb17006cfd49cdbd2034f3240f47ed5e88a1031811f4e2bcf3"
  license "MIT"
  compatibility_version 1
  head "https://github.com/OSGeo/proj.git", branch: "master"

  livecheck do
    url "https://download.osgeo.org/proj/"
    regex(/href=.*?proj[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "448e0ca2bcb98a0b5df650a414bee47ea40b2eab716dafde9b7140bd4aedfb02"
    sha256 arm64_tahoe:       "8a4962d2d4ca39f6556c829a94cd00e9727ea1faa64a6950817da69f75401738"
    sha256 arm64_sequoia:     "d3a42ecb622133bc6dab5cd9955a7acad277cc232bd481850b4214dc83656891"
    sha256 arm64_linux:       "0ec698e513dc01e29b036351cfdcaf7faf689fd495739928373325652df1bc25"
    sha256 x86_64_linux:      "6dab4744f2f1e4eb0dab400a05cb6873c8a925426dd315473f4b94e9759847e9"
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
