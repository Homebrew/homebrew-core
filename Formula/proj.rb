class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.1.0/proj-9.1.0.tar.gz"
  sha256 "81b2239b94cad0886222cde4f53cb49d34905aad2a1317244a0c30a553db2315"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "c2fc067271d23d5251a8448f9980e58abdcc901469d869a84800ec9047c9ff3e"
    sha256 arm64_big_sur:  "f599eb7a880fa923ab464eedb1a57b84ef7b72355893a67d4fd008eb8869176a"
    sha256 monterey:       "bac994a37c6330d1c446b6ff817cd6a5abb041fb239a5d45a7cf940aa0c56058"
    sha256 big_sur:        "b8b0f822096fae82ec8ee81d31a78c5f58834b63f0e20da99223f8f051ebff01"
    sha256 catalina:       "fefdbbbd06bb34124d4c5475c4a1acb426aa575fa0b6dc9140f6c2a5da41efff"
    sha256 x86_64_linux:   "d261b008621c4a7362ecb4d62ae64dca94f38ab924be673091ed8fd754690acc"
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
    url "https://download.osgeo.org/proj/proj-data-1.11.tar.gz"
    sha256 "a67b7ce4622c30be6bce3a43461e8d848da153c3b171beebbbea28f64d4ef363"
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
