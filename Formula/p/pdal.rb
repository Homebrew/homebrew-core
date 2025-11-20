class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.9.2/PDAL-2.9.2-src.tar.bz2"
  sha256 "a74bbc7f4e4f709ed589dbbb851926a63c391c974e3fc40a4c3ff34f7923021b"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98585021c9f28998c8f4b02acd0afaa95333a511202f354f274926a2302877ad"
    sha256 cellar: :any,                 arm64_sequoia: "0dbb4e6defdfa477c47ae908bc91c74a92d642099becec3ffffc1dcf39e79695"
    sha256 cellar: :any,                 arm64_sonoma:  "af547fbe07505536962385a3cc3cd7ed6f70a076f955ce84623b6b9e4b57e68f"
    sha256 cellar: :any,                 sonoma:        "a568c83c7018724799519460f5875d1f5e55514ba22bc9418cf32198f409d064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1b5aa61874acac22d42f16cd83f52605fd79daab8a091cd96439e0640f71972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9498a5989a17a565b0fe4c4f364434b47aaff4bd16e8d030ecacb623a456560e"
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
