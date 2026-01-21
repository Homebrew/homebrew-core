class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://github.com/PDAL/PDAL/releases/download/2.9.3/PDAL-2.9.3-src.tar.bz2"
  sha256 "22e90c8b9653e2bd0eb24efbe071b6c281e972145b47c0ccfdc329d73c188d9c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd9574824b61bfaeb03e419f2f8419ecac5dad68e26d9d4e1265e6269ae2fdd5"
    sha256 cellar: :any,                 arm64_sequoia: "9cf2120d17fca9e35c805e00855fc160f83053f5b8d36618960c93361669fb3a"
    sha256 cellar: :any,                 arm64_sonoma:  "22281c24d53bb3204a454b039c92c0689530be0734f51aa1606299e4c8363d88"
    sha256 cellar: :any,                 sonoma:        "a488265cc57f828e1965cbcf716bd82cc8c9ca3da1c057d9a8aa8e9d55a47c65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8031c642131f178ef0d5a5c9a7d47ef63322e2f75fe110a1d2e9abfff6b647ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f79ecc846531cf0002193d1c2951749670bf939eccc5a51f49f74f59db400d72"
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
