class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://github.com/PDAL/PDAL/releases/download/2.10.1/PDAL-2.10.1-src.tar.bz2"
  sha256 "78765f1d06584c8e9b3b4a5b58c0ebea478d42ad21f1432717b31c20def05522"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "514334b718dfa268bccc32a0e0a9746f30c70723cdc8d2c88f8be9eb14b40cd2"
    sha256 cellar: :any,                 arm64_sequoia: "5021ad771b3d7391924fb5e756c553d8411e3e7eba0052ea27f5f0ffd045490c"
    sha256 cellar: :any,                 arm64_sonoma:  "a9814e248ace650336500ae1d02a1e0716d3acc64253a332262e363000e4efd8"
    sha256 cellar: :any,                 sonoma:        "a2d04e5af7925d00d5b00f2f4719e8c6eef140d62f467449c3e80d63e5e08907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11aeea44e1318ae538bb09b92ada6ac9dd64d1f70c521e9241180884e14b7caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f423839c855b2c0fe0d43a303d4f828080aed7d8488379e6cb82d551508ee5f3"
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
