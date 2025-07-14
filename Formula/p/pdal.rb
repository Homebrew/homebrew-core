class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.9.0/PDAL-2.9.0-src.tar.bz2"
  sha256 "f0be2f6575021d0c4751d5babd4c1096d4e5934f86f8461914e9f9c6dc63567d"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df3625f29b78818e5612df608c7285c427d61a4f958a1bbc12f2c2acd6102a7d"
    sha256 cellar: :any,                 arm64_sonoma:  "0deebb7f4aed87f93e8a8312bfbb7b345ddaab7b38976f977cdb9cfd5d144265"
    sha256 cellar: :any,                 arm64_ventura: "c16bb2d479d3012b3e68089d525679da0c033282cd4b8420f698e4e97c414c2e"
    sha256 cellar: :any,                 sonoma:        "7a67735f291181d21846502f6e8fa6d132b148ec524a78445f24324ce6ed8535"
    sha256 cellar: :any,                 ventura:       "a8c294bf0ac08b50c658d4a293ffc19960da1e17b360184c435607cf2e80a37f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a3edab3708912af7677213c85466ef1ba09e2cf01b527db65e9dc241e0f2383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135d54d4953876f23dcfa6dd5ce606cc29ffc8711ee549305aa1170bffcecfe2"
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
