class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.5.0.tar.gz"
  sha256 "2abf3126729793732c3380763999cc365e51bffda369a008213879a3cd90476c"
  license "LGPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "763bb8ccfd0bb15d17a767e6d97c3b362a2a76fb714c60f09886b9ba5fb97203"
    sha256 cellar: :any, big_sur:       "9e337cfcc57c6ed65e610402020949bb6196aac9302fa8a57ce1cb73e9cef8bd"
    sha256 cellar: :any, catalina:      "fc5fd1938b21d5c3bdc547e2797596b3e794e184a18c1b5e26fe99b91723fb04"
    sha256 cellar: :any, mojave:        "5cae6c5d1003d205fad343e3a8272f4b1432519a1d8d66117edd25cd3980cefe"
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
