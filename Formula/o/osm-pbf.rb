class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "656693464a84370602be8ebfc7a027510712026fbfd3da69fb27ccbb8c1358ae"
    sha256 cellar: :any,                 arm64_ventura:  "368660ba31744e1294832f9d4145d029dab551d555fcbff47beb1513ca9308b3"
    sha256 cellar: :any,                 arm64_monterey: "132758dfc09f85b61d287e2eb8d82969a9553124fa35cfb02e4add149d413b5b"
    sha256 cellar: :any,                 sonoma:         "d8e50f6f8e3e1953afd9afb78f7eff8471b39a08eafac5d186b0daf619b89a0b"
    sha256 cellar: :any,                 ventura:        "0cbe569273fc87a85943131b2afa2733efc6ce46e9974f2275810054f6d34ecd"
    sha256 cellar: :any,                 monterey:       "1f2af2b96a7ad23d76c30fd93ade898c9faf072b26862b640c860a4bd788d5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9b099bce5548ce8f878771dbe935bf4cfaa4183ea3e22b522f6de820a1fcc3c"
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
