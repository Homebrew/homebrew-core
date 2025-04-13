class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed7762d14a46871ddbed1b0dc1c0ab5232c679650fc4f7d26e1a2f00f5d1a39d"
    sha256 cellar: :any,                 arm64_sonoma:  "31d0e2574171450149af2225ce6d8904de1b1ecc057a3cf38114de3e0873f432"
    sha256 cellar: :any,                 arm64_ventura: "3d76915fded9c47bcd48d982cbb569f20580eb8d14013f66a1d4111b7aef64c8"
    sha256 cellar: :any,                 sonoma:        "764fd73e39d4ef37c2197000d2e160b80075efe6b18f93fdcb1b5a9ebc9000d3"
    sha256 cellar: :any,                 ventura:       "5d243d081e1840bce4a5af93bb1ed38db77bb8e40a62680d6f2ef447af312696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce7769b6bc5da9b84f3219258c70461cb2457534eb78d218d65dc8d7cd39c7e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384056a52cfb9450f57f3c7f41654a988e10b5cb0d5cd99c3f275ea7f7332aea"
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
