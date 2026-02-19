class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://github.com/PDAL/PDAL/releases/download/2.10.0/PDAL-2.10.0-src.tar.bz2"
  sha256 "65eba26e24a2cb1752d3542cc84e8035ecb8dc890b72145128f9b33bd184f2f5"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e0016f885a83d366f0bceeb076869ce9d82197cccf15e92b20250a4b01c3023"
    sha256 cellar: :any,                 arm64_sequoia: "99e61a32ee87f0ea38d9f3b85fb950166f7e7ab09065d806bfb1d041b3457b07"
    sha256 cellar: :any,                 arm64_sonoma:  "e1f14867f06d20cebb682238598a216689349c1b381b65ad7e6740a328db6ca0"
    sha256 cellar: :any,                 sonoma:        "0a60db38ee951ecb87fe733b021cf83073e11ddf5b690f994447e1d2b34b1f38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03153aa21808408e7c45cf6eb79bf6893dc79205024ebe1b838d1350bc023925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca80129201d5d8c311e15e15e275398b053a662ba6df24ccf0ac003322b5097"
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
