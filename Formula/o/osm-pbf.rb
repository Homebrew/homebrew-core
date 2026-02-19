class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "54e0f234ace310a4256dc7d4fc707837f532a509cc3ef2940dacbdc4ebd9ce15"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "72b93dac765bebff59d981fdeed0830c7bc72772045e674e7553aba449a7762d"
    sha256 cellar: :any, arm64_sequoia: "4b0413ce59ceeb4c695bf4e7ee5245efdabfed592d9c3b9eaa57152fcd9b46dc"
    sha256 cellar: :any, arm64_sonoma:  "efadf44f4e19b9335edb1c39e3cb34812f6ce7b554d3b8a1a410ae7b3d8d68eb"
    sha256 cellar: :any, sonoma:        "02e1ae3d72fe7022bbdbdc685ee01406858326af8d2d407d55b705edddc2ddaf"
    sha256               arm64_linux:   "e6ecc027c312ca997108b0deb6c3a4dfd75a89be0bc7717658af2464ac23ea13"
    sha256               x86_64_linux:  "90f7c574f9ab83e3db91f7e7bf0ec53791116df6326d17f0a6a7790ebb97259e"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}/osmpbf-outline #{pkgshare}/sample.pbf")
  end
end
