class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/v1.5.0.tar.gz"
  sha256 "2abf3126729793732c3380763999cc365e51bffda369a008213879a3cd90476c"
  license "LGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83186e7dc2a8237fb480072b716ca0a3d274002bef9f1cda3bbaa00917324b78"
    sha256 cellar: :any,                 arm64_monterey: "0b4a492003e5dd41f96fbc40ca087cc64f7651992b65b7028434bf3c4c20eb74"
    sha256 cellar: :any,                 arm64_big_sur:  "b7db0864c304ea5d04094b88c0fa078d49424fa98950aed10f40ed596ef9b194"
    sha256 cellar: :any,                 ventura:        "e24048c59c71a33485bfdf59a13e220318a590618ea076650753e3fd052c10b2"
    sha256 cellar: :any,                 monterey:       "c9c32991c08e164406494c12a5c3c9ad3b46ee249386cb5777068b1d1b12e80b"
    sha256 cellar: :any,                 big_sur:        "2a1309dd7c2a7634add17179732f452415febfb6b2a39b8f498b57f4d8ee222d"
    sha256 cellar: :any,                 catalina:       "6cea77ead1d01a4516a2a8e20a38a0dde0024eade075fa0738ba0f6910bb5df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1467f12dbe00979de9bfc47c37b59d2b918938a78ae9d476091902f886685f44"
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
