class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "25c892e28297ace680026dd5163def16b16689401b5fa5f43813518c3f97076b"
    sha256 cellar: :any,                 arm64_ventura:  "621d1bf4ed8bb5ebee329f3423eea92cfb213c63db819ed0783f1f05d3b502ac"
    sha256 cellar: :any,                 arm64_monterey: "47c252c272667bcfe6174a7f0f2913a6558cbbd4257b7e6090ab222b4543d321"
    sha256 cellar: :any,                 sonoma:         "ceb8fced1676874363c4c2179673c210b9e5e6783c2e3e9095ab4e2298bcc97a"
    sha256 cellar: :any,                 ventura:        "34d3ee3c13d529988d6ec962080a47c66ca1d0b7b8c07224c30d83d509cbcec4"
    sha256 cellar: :any,                 monterey:       "16c6317870b15361ebc79c8d8ea0d9c602f905c7aa3e82421a7e38dfcfe4fb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6da020391efcd6298b18d2b25bdd91688f40126c3f84dd27df9af2dfd3929dc"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "zlib"

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
