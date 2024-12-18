class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 12

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89d00935034bcfe66271702b0672072e864e08ff70cdff05aff3d1422ff028a0"
    sha256 cellar: :any,                 arm64_sonoma:  "6fa8b2d2a7b46403a31dd8c137302a786246e1924522d2b0d6db6eee43d1b5c8"
    sha256 cellar: :any,                 arm64_ventura: "89f1460a048af812cb71c06384f1143ec6096874ac592bc2c0f13a769f9bd1da"
    sha256 cellar: :any,                 sonoma:        "ef02fb7b3bd067ef85ec1213a88ce3548d04d6b277b07e0156027a6fe8470489"
    sha256 cellar: :any,                 ventura:       "3a9cabb4d421ef5fbc9785b89e0cccdca8bd6e2d7c9ebb2510c6e3969519ff5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "887cd89aa901b0de97157a7d6b6e642349d36714ff22fb2d6953781971f37e8f"
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
