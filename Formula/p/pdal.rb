class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://github.com/PDAL/PDAL/releases/download/2.10.1/PDAL-2.10.1-src.tar.bz2"
  sha256 "78765f1d06584c8e9b3b4a5b58c0ebea478d42ad21f1432717b31c20def05522"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13320c43a9053593a7bfededfe94fcb0962ab0df1548bf37ec7d79f3f9a5d6b1"
    sha256 cellar: :any,                 arm64_sequoia: "57868aa56026dd8ad70cead0ae45cc220e8f9b74700db2d1e12e46c04e0ab8d6"
    sha256 cellar: :any,                 arm64_sonoma:  "adc7ca68e794337bc7e2fdde93901c71ac1d7820c64392ed138cf2af289edc76"
    sha256 cellar: :any,                 sonoma:        "dac71a7ed9a5b45661f561a12b67d6171b33eda715e15a394769ab70a19cd4de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bba70f9f78601d5b0b31c06b51f654ce3c9812c5cd9b5e8dcade8efa78ae2526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19de87c23362ea932388228f2ef2a00f4c45f8ee9ed9b9653fb5188d981e0edf"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build

  depends_on "apache-arrow"
  depends_on "curl"
  depends_on "draco"
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "libgeotiff"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "proj"
  depends_on "tiledb"
  depends_on "xerces-c"
  depends_on "zstd"

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DWITH_TESTS=OFF
      -DENABLE_CTEST=OFF
      -DBUILD_PLUGIN_ARROW=ON
      -DBUILD_PLUGIN_TILEDB=ON
      -DBUILD_PLUGIN_ICEBRIDGE=ON
      -DBUILD_PLUGIN_HDF=ON
      -DBUILD_PLUGIN_PGPOINTCLOUD=ON
      -DBUILD_PLUGIN_E57=ON
      -DBUILD_PLUGIN_DRACO=ON
      -DBUILD_PGPOINTCLOUD_TESTS=OFF
      -DWITH_ZSTD=ON
      -DWITH_ZLIB=ON
    ]
    if OS.linux?
      libunwind = Formula["libunwind"]
      ENV.append_to_cflags "-I#{libunwind.opt_include}"
      args += %W[
        -DLIBUNWIND_INCLUDE_DIR=#{libunwind.opt_include}
        -DLIBUNWIND_LIBRARY=#{libunwind.opt_lib/shared_library("libunwind")}
      ]
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm_r("test/unit")
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
    assert_match "pdal #{version}", shell_output("#{bin}/pdal --version")
  end
end
