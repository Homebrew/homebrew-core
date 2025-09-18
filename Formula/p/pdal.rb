class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.9.2/PDAL-2.9.2-src.tar.bz2"
  sha256 "a74bbc7f4e4f709ed589dbbb851926a63c391c974e3fc40a4c3ff34f7923021b"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21cdcfe4658aaf1a1a40dd300b9fc6903bb02f9c98f87dd52113b43c15247d00"
    sha256 cellar: :any,                 arm64_sequoia: "3129cf73d69a612f587f0b9e421ee026618df1054efc2cedf7fe9aa0630cebca"
    sha256 cellar: :any,                 arm64_sonoma:  "5fbc01b27bd59193bc60583fe900beb894cd9c119ffa8f0b1d45b0dae0074237"
    sha256 cellar: :any,                 arm64_ventura: "7c289fafa602f7e1fd481c86985dc4cac1b0522df95728b3469737be107bd50c"
    sha256 cellar: :any,                 sonoma:        "cfa5775522389344389599cdcffa166664d36972a22caed3376356d244753e65"
    sha256 cellar: :any,                 ventura:       "0d29af37383f6ad87263fe5a5e34f79d328bfd34639f9ba3554be0769ade074e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8f1c16c603a0a238c2d07d2c9110893948853374bbc4be116d4e892da337fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd32a2273fe12d7f30c99022c091c330963098464e029e9dfc13c33a49b10d06"
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
