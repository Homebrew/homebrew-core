class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.5.4/PDAL-2.5.4-src.tar.bz2"
  sha256 "db9231cfe3d5199075aca6e479a3b9fced1d090a300bddc938717398d3e58c4b"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  # The upstream GitHub repository sometimes creates tags that only include a
  # major/minor version (`1.2`) and then uses major/minor/patch (`1.2.0`) for
  # the release tarball. This inconsistency can be a problem if we need to
  # substitute the version from livecheck in the `stable` URL, so we check the
  # first-party download page, which links to the tarballs on GitHub.
  livecheck do
    url "https://pdal.io/en/latest/download.html"
    regex(/href=.*?PDAL[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "d3d23e30886504c10586abcc4c9e15211a6f62b4a38f76231a3435c8e49b451d"
    sha256                               arm64_monterey: "ac705dcadcdc57641afbb38184f587e18ea160a5da3ef7f7c39139dfcdb6b0d1"
    sha256                               arm64_big_sur:  "8db64da44073ca9c59bf8e3f4a6ef9451da2e43fc91764edcc02b1f864d54fc3"
    sha256                               ventura:        "f31e5b71c57ce8b08dfcc1652065d535605fd738cbfb2e93c1eaf652d941abee"
    sha256                               monterey:       "7ce7d8a42978dfa8759a59f94e4d68007e0aebbcbb64985e29b74dbf0ad37962"
    sha256                               big_sur:        "6ba8e735533d4cd026cc12f51c765d6cdf5628c2a77bc3ce5aa20bd94e3b3f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcee17ab98c8fc7837149cc2eb181a06029a86f1a55c964ca89b54b2205eee00"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"

  fails_with gcc: "5" # gdal is compiled with GCC

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_LASZIP=TRUE",
                         "-DBUILD_PLUGIN_GREYHOUND=ON",
                         "-DBUILD_PLUGIN_ICEBRIDGE=ON",
                         "-DBUILD_PLUGIN_PGPOINTCLOUD=ON",
                         "-DBUILD_PLUGIN_PYTHON=ON",
                         "-DBUILD_PLUGIN_SQLITE=ON"

    system "make", "install"
    rm_rf "test/unit"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end
