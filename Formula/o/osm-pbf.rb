class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "54e0f234ace310a4256dc7d4fc707837f532a509cc3ef2940dacbdc4ebd9ce15"
  license "LGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8c094a9155bd427aebe8c0596c39bfa8bb1baa6e37a6e67d6c464dd3a9406c2b"
    sha256 cellar: :any, arm64_sequoia: "f262436c3edf7b78111037c7e50488a7f58c2864a5619a2704fe18484d0192c5"
    sha256 cellar: :any, arm64_sonoma:  "f9f25c5febe9fd13e5a6f6e55526782ee8d9f3daaa850138b4404e2b127fad6f"
    sha256 cellar: :any, sonoma:        "edb5cffe179d086f72390651d8f4305e641cbbb35fa9f5795c78d45563765b27"
    sha256               arm64_linux:   "c766d1cb11831c25860831ffd305326cf8945fdae82e65e916c6dd2c2bda2b87"
    sha256               x86_64_linux:  "062a82e9c406aa3914c81a5882dcc35bebc4cf6f5c9ad7d9ba4c1cfe84b8e495"
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
