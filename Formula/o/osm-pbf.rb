class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 20

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6a35c19765a72f46117e2d89d2c519bddb85977b0029f0e89eb7a65ead8d77fc"
    sha256 cellar: :any, arm64_sequoia: "a8b8b54f235199aa030801a00c70e6c2a78717c46a3bf16b66b6011b0daed046"
    sha256 cellar: :any, arm64_sonoma:  "23ffed6d92890d9335e4cb5b13eb6fb5a117261367a175dfc7435ba067ca13da"
    sha256 cellar: :any, sonoma:        "ef600051c5903691c5cccf4d72afc3983eb929e42afd07f6b21a6f8d13784834"
    sha256               arm64_linux:   "3fa37eed3cfc28cd112648275b6c76e6830683a774972acafed249a47dc0c435"
    sha256               x86_64_linux:  "f44b56f28d66f37287099ab013fd0fb245b0a3d94f90e081b801864c247bb955"
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
