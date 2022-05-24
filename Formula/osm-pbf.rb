class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/v1.5.0.tar.gz"
  sha256 "2abf3126729793732c3380763999cc365e51bffda369a008213879a3cd90476c"
  license "LGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c54ae6cece29667791513344f8ca1f07412dbf7c0030eb000c835864dda96b7"
    sha256 cellar: :any,                 arm64_big_sur:  "91108e1f36a68528f39a4c90a15b21de280f25e1846b7b7d2014e056d8373308"
    sha256 cellar: :any,                 monterey:       "df65cb7860d85aaf7f2b0273cd4bd36438440120e275580c72cb118051bf63ee"
    sha256 cellar: :any,                 big_sur:        "3e563c0635212cdbad3330addbbbb32e054ccb64267d8dc28b2c79ce223d1c2a"
    sha256 cellar: :any,                 catalina:       "4e43efc37899fb2ea13d831f24ac192fec230a9265e25337fbbffdb4c5196914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72f304c07b272e036f0aea9601c22d1e06cb44376bebb4d26cdefdf994c1d429"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}/osmpbf-outline #{pkgshare}/sample.pbf")
  end
end
