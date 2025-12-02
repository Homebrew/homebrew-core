class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://github.com/PDAL/PDAL/releases/download/2.9.3/PDAL-2.9.3-src.tar.bz2"
  sha256 "22e90c8b9653e2bd0eb24efbe071b6c281e972145b47c0ccfdc329d73c188d9c"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd8edfaf04fd85708b5ddbeaed8f6be17d0c6f9bc2b6bbca926405774726a437"
    sha256 cellar: :any,                 arm64_sequoia: "03b48179fe5a241f4eb6f7d4380809ab7c329e9532d8c4864ed45c7c754eef99"
    sha256 cellar: :any,                 arm64_sonoma:  "abf1b0bbb6bb3ff74c39e993ba87172b5f41d4398e0eb3681402803c9f8b3aa1"
    sha256 cellar: :any,                 sonoma:        "7123cbaa670ff74c93a7409e9f118c8b85bc2a4d054e6a1cb18725bf8018cca3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8c4761cfb2b0673c61d8c8b8b56474c8b4c8d9a2bd00bcc4d0813c80c2f033f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "897b979fa14e65d3aa71e417ddf8cc21211676e5aba4ac834738aa9cc8c037ac"
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

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
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
