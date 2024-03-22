class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.7.0/PDAL-2.7.0-src.tar.bz2"
  sha256 "a4e480b6a3a1967a65cad68ac02cf156029d67fcf3764def6ed235639826c1a5"
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
    sha256 cellar: :any,                 arm64_sonoma:   "19c22d49e9f5e1e74b0e18a294121c7a2a0181886c73bcd4636be7ba3d72401f"
    sha256 cellar: :any,                 arm64_ventura:  "190dca378ab836e4c84414115c85677d8931b8424210af3fd227d8aa651fb1c4"
    sha256 cellar: :any,                 arm64_monterey: "5f6aa7b559b2c08af9328a578ca6aface3b905193c4bfc6a479bf77ddba407b7"
    sha256 cellar: :any,                 sonoma:         "ed59b25b0ecd9397028c9025bb87df61a9cd9c98d357dedef8caa7fe8de9f15a"
    sha256 cellar: :any,                 ventura:        "042932e8c56aa93960d6202165806ac827c5b5f392bb953f148dd4ba56579fb8"
    sha256 cellar: :any,                 monterey:       "66aae785b4cb85582ea55457783c607fc98a97be36caba8a59d46c23429bf01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10adbe9115257b5fd59a0c98ce1e04a9fa257bd55aec84999e8360d2043402e1"
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
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 1500

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
    assert_match "pdal #{version}", shell_output("#{bin}/pdal --version")
  end
end
