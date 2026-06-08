class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "54e0f234ace310a4256dc7d4fc707837f532a509cc3ef2940dacbdc4ebd9ce15"
  license "LGPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "03b8c18a1f43e52e2a440a033d88e8a32e4d52ce725bc826e9d6ee8fdf9a6ec4"
    sha256 cellar: :any, arm64_sequoia: "100151829a3af616fb0558ff88b884fda3573221d062dccadf1f5ccdcedf3ba5"
    sha256 cellar: :any, arm64_sonoma:  "ddbea381cd744828a75101ea8c2397baf85b27e1e01b98b61e4473c01f7d61c8"
    sha256 cellar: :any, sonoma:        "a2a094fb6ecc7b82e64b5dda75dc3118206d5d514a8c557e3fb923cbbd7f790c"
    sha256               arm64_linux:   "0b361cc5af976eddd1afd9a8f4e3dc104aaa5ecfd6f1a1e661849e50e469db08"
    sha256               x86_64_linux:  "c855cffe69ae03534363bbf06c7614f77b6b4e5c61f20866aa528e0d81e0cf6d"
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
