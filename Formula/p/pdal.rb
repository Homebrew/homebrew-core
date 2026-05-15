class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://github.com/PDAL/PDAL/releases/download/2.10.1/PDAL-2.10.1-src.tar.bz2"
  sha256 "78765f1d06584c8e9b3b4a5b58c0ebea478d42ad21f1432717b31c20def05522"
  license "BSD-3-Clause"
  revision 2
  compatibility_version 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02deedfb1769a0487800fa7b95d59de7090052b19d2f91f1d7e5c6da24f8a3e6"
    sha256 cellar: :any,                 arm64_sequoia: "55d452bc08f69baa055e69e993f2d5ea0fcb23286802526f12252be47cf96ee2"
    sha256 cellar: :any,                 arm64_sonoma:  "9c0c7df209df73486cf970ba047bafb94a93ef5c324c98b6ff85e6f56ab95fd6"
    sha256 cellar: :any,                 sonoma:        "e9804142b9a27b338eb42420e9d332b8751cce6072839e99ad4f3d6955542951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "648a369223ec298af9f32f6f7c592099b02bfec45e17cc2ebe27f33c4197365e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "350452ddafa300c5e6c08b69f908f40f552299238cb7f3dd9519480ae1098131"
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
