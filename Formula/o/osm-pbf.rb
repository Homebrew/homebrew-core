class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 15

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69811bcdcabf559be5d28dc3c2d3271f242e5007e944af22b7db616a404b2245"
    sha256 cellar: :any,                 arm64_sonoma:  "66edfe98b40a02a69268df02b336b46490ceecec262d7e06b7b9a7421757f1bc"
    sha256 cellar: :any,                 arm64_ventura: "829ffeabf5130d4dbe72fe79918cf76f428a51c46571a999b1b58544a8eae758"
    sha256 cellar: :any,                 sonoma:        "e54ece472153e4a1f60ff6c072b5d25f30e374d5cd9c2a0a56fb85483d383125"
    sha256 cellar: :any,                 ventura:       "4dc7068a3093e8b717cd58bc3dbb42f0359e0063fdea55dbfba4ad8039ed7d05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c14786cd95fb98556893a5d867613993eebbaefdbc3b96878cea7f00cd3bf29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69e633c55ae5185a75d3f3a06b34bfeed20ba4811f0513c4ad0a79d367ba47ad"
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
