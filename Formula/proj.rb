class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.0.0/proj-9.0.0.tar.gz"
  sha256 "0620aa01b812de00b54d6c23e7c5cc843ae2cd129b24fabe411800302172b989"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "62cb9712728f6564c3a16dbc0ff0039018190140006a116d859f33d74b25ae97"
    sha256 arm64_big_sur:  "14de62fb7c0938043e569eeb2bfe0a5f9bc210a1e01cc0fdc6cd5bd1a39fd582"
    sha256 monterey:       "6e01afdab9239b4acade4884b58b0e7e27621caecdfb8d8f21edc7d77f8c0d42"
    sha256 big_sur:        "bf91fd3fb71763f796699e3cf8dcfc477c31cc6f9fd579fec6a489d82c7fbcf0"
    sha256 catalina:       "f6af4ae5830d82a9c9c4aa6f36d91a8949bd025b46a3d778c3ad8a7cdf63c854"
    sha256 x86_64_linux:   "402f0a4d03f0fc03f8ee6faa81dd13bf7e207d3df58de2790c9e51e950ac1725"
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
