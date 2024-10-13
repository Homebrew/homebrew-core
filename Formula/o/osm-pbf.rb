class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8125d2a217d5ce83df6db4ab63148f5b364bb23d28d97e6aed0ad4196c5603a6"
    sha256 cellar: :any,                 arm64_sonoma:  "69192e5044001b5e1c09833c8f3fa167dbdb050af1302729f4beb8c9bd7a3351"
    sha256 cellar: :any,                 arm64_ventura: "4bd507eb7d86c527fa94925f83f17b8a02f19d6f5136b08521dc376278116bd8"
    sha256 cellar: :any,                 sonoma:        "c92254cbd852c4c7845528139041cefd8d61129a199dceae3d32ea7a3426a215"
    sha256 cellar: :any,                 ventura:       "4365f28078ce4ca84fdf7cc8448d77ea46bf2259e7d8641dfaac9d3f6ddb0773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cabd4c7c2bfe38a23d7d3b40ffcd187ca0a4727acb47f1de21a71d01e76c576c"
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
