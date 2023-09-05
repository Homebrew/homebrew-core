class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.5.6/PDAL-2.5.6-src.tar.bz2"
  sha256 "7c7c4570ef518942299479cc4077e0c657ec5b5174daf465415de947a1d3eb99"
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
    sha256                               arm64_ventura:  "907016c2faf1e258115d68d664ecd49a6c17df7dac074e669932643e669c4c81"
    sha256                               arm64_monterey: "d7e219f143d23f14b6fe5a808ef37fcd6a90c37d6ead0a942acac6cce2422647"
    sha256                               arm64_big_sur:  "41ef2b8263849cdf7ebaf6127e73997f41e2087abfc3ea5d56062e4138d9c24f"
    sha256                               ventura:        "cb89ab55cc2837bf223f855d8e13aa2bae41a1ce65312d2391a6f6fd3ee3dbea"
    sha256                               monterey:       "8dd43f33d18cc4f8d9bb0cd46e2f445ad4e43cbccbb3f98625cc3e2c4155fda5"
    sha256                               big_sur:        "e449cf49e82392a9d257aac914298d4aaffb7c136e853d3f8f697cf6d97e1ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e7a2b4eb9accfaa73a653ad9d91d9b3d31e30f209d49fa86d92d658fc721279"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"
  depends_on "openssl@3"

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
