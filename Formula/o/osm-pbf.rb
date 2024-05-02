class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a7bc9685fbd4accdf521f0bbaf7e29a50fb429081c1bf7c0f073411d645e207"
    sha256 cellar: :any,                 arm64_ventura:  "846994be8e4c0588d6b45048279bc8fdf799a96f501cdb5754583d986f6e10a0"
    sha256 cellar: :any,                 arm64_monterey: "f11b0d8d6a3a5425a29dcd89103ade24d1fc60654de926ffe200ebc019d35801"
    sha256 cellar: :any,                 sonoma:         "db6bf07c673a0cb80491d28dfee9c256e9ab37ca08dcfefffbeacb43e355fdae"
    sha256 cellar: :any,                 ventura:        "07c8750b26853d5181397051861d69c65d5c44ed32cff18d0e69400cff53c5dd"
    sha256 cellar: :any,                 monterey:       "bdfcb356ac1ddb180c48ed3c0361fcd266d7e735fb098b36bf1d69cfc0cc6c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "057faae51e178a236e2f2b514c8348117187932a1ad49967cfdb28ac6ecab1fd"
  end

  depends_on "cmake" => :build
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
