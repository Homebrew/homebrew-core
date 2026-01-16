class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "54e0f234ace310a4256dc7d4fc707837f532a509cc3ef2940dacbdc4ebd9ce15"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "39bd87808dc4008832666b8fc249b80f6d33c4777a82ed0b577b0f7622a6f84c"
    sha256 cellar: :any, arm64_sequoia: "9c8ae16e7656e0e07523f60dfb831fe256490cf3fb336cef55507183f09c273b"
    sha256 cellar: :any, arm64_sonoma:  "1755c0276429fb4739a3305f4fb1ab6f2db77fde780d11e3f7be5c2663063a7f"
    sha256 cellar: :any, sonoma:        "830d3161bd7331fd78713e9109a0123895e66e8157b3559f3eaa4ea46392f0b9"
    sha256               arm64_linux:   "15a45ab0e94aecff4e02151bc3a91ccca59346d3c2b23bc488403ea7b7e9e6bf"
    sha256               x86_64_linux:  "e049d28c8808d1bd449ad5ed3bf6288f432de2d66e27245ac5ca81ec7b100f10"
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
