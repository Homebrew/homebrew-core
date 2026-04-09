class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "54e0f234ace310a4256dc7d4fc707837f532a509cc3ef2940dacbdc4ebd9ce15"
  license "LGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "efa9ec4c88fce093231dda6d01c5c186e6eaf49e8b3111a8b4a483dfb9deaf29"
    sha256 cellar: :any, arm64_sequoia: "36b5fbab0654ed6c5ba595eee77c40714807c03404bcddf8bcfdaa7518e5dfe4"
    sha256 cellar: :any, arm64_sonoma:  "5f93d0f5a50928ac7efeb37f0dd47ae5033d223e5d4f31fe79482f7c7d015c97"
    sha256 cellar: :any, sonoma:        "998c95eda22cd5263043bf6bfe403c4873f4744e1ef07d1436362e4ec7d60b59"
    sha256               arm64_linux:   "e5d7d87329769c170fa095870c7fb69c5c82bdd6efe76b18419fee7dccf270e0"
    sha256               x86_64_linux:  "706b53b3862894251ca3318edee85fbe72465bdcb6a4a862de3b07b547ea6ab2"
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
