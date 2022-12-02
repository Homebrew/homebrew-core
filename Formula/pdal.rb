class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.4.3/PDAL-2.4.3-src.tar.gz"
  sha256 "abac604c6dcafdcd8a36a7d00982be966f7da00c37d89db2785637643e963e4c"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  # The upstream GitHub repository sometimes creates tags that only include a
  # major/minor version (`1.2`) and then uses major/minor/patch (`1.2.0`) for
  # the release tarball. This inconsistency can be a problem if we need to
  # substitute the version from livecheck in the `stable` URL, so we check the
  # first-party download page, which links to the tarballs on GitHub.
  livecheck do
    url "https://pdal.io/en/stable/download.html"
    regex(/href=.*?PDAL[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "9f266bc1f0655e3cf6f3e970b0fd869716ab969fdebd1fad0d8c3c35b25fc5c3"
    sha256                               arm64_monterey: "dc51e691abc1addb783ccef70b006726157aaa7caa273915c510786a84308f0b"
    sha256                               arm64_big_sur:  "b0d6b2aa4949d66291d466da7825cd5e7d30563b7e3d8382c54e2b3a2b2f3b20"
    sha256                               ventura:        "5f55e06253c50aecceebfa7f7cfbbbe1539d90919293d14d479562962e643c85"
    sha256                               monterey:       "a905636f17a9e1ee38779d5a9c4150c08d83fab77c0df2f88719bec1b169694c"
    sha256                               big_sur:        "6733756720845ac0549083d287557fc2653290e0e8e51a4f963f31f34d5bdbf1"
    sha256                               catalina:       "893847c0127b8c653bca869f62f1da1b7dc3fe96d92eec64adc563c3448316b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3073d9958ec6aed15a1ed50d930a64534a3264081d5b998eca40ec09f172afa8"
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
