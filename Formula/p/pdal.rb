class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.9.2/PDAL-2.9.2-src.tar.bz2"
  sha256 "a74bbc7f4e4f709ed589dbbb851926a63c391c974e3fc40a4c3ff34f7923021b"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6185f73d006d25ea279e9e4a85063b5f207b7cbbb65b80060ae71e56db3493da"
    sha256 cellar: :any,                 arm64_sequoia: "a424e98f10b68c23edf902d609844c51d75ec9d3ee655c22a935db8533f17515"
    sha256 cellar: :any,                 arm64_sonoma:  "27db6d9034170ddb1377382658118e2ad7ff0c008a60c9c39ebf09d75b43029a"
    sha256 cellar: :any,                 sonoma:        "1e987269aa3c99c261a9819f0f32ed29dd59ab4fd0891f6a63fa0abc35c5730e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "769e273a3af7fb2928b12ed434c07cc762048d6dff1a2ec4b8044ef79dd847f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a01e19a3b2c6d2f1c8b540eeebd6221d87119c88697f712899f3c0be3b58de96"
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
