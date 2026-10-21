class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://pdal.org/"
  url "https://github.com/PDAL/PDAL/releases/download/2.10.2/PDAL-2.10.2-src.tar.bz2"
  sha256 "882b97aa3ae5db682c3b2dc8edef4e29bcc7ecea51c70592e71bc1f34112ad00"
  license "BSD-3-Clause"
  revision 5
  compatibility_version 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "783c15e6bf7e49253815da2726c19767f34f3653d84890039b9172a33bee8df5"
    sha256 cellar: :any, arm64_tahoe:       "e6777fb7addc89a6e76d9d7f007dd45fce8deab9d71aa9574dbfadca6ca3a8bf"
    sha256 cellar: :any, arm64_sequoia:     "cad0162986621ede8b77c6bf8428e2ec61f93f742631a750f41482df12b1bfa8"
    sha256 cellar: :any, arm64_linux:       "29ec31fea2786c6016a6b79230b8c3f18410c06100cb3bf9dbdb73fcfe4f8971"
    sha256 cellar: :any, x86_64_linux:      "a81ff11ebe3874d78399ffd4f9e8e946ae14b8138d9947a13768281be46e41af"
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
  depends_on "openssl@4"
  depends_on "proj"
  depends_on "tiledb"
  depends_on "xerces-c"
  depends_on "zstd"

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  # Arrow 26 API from PDAL 2.10-maintenance: PDAL/PDAL#5078, PDAL/PDAL#5098, PDAL/PDAL#5100
  patch do
    file "Patches/pdal/arrow-26.diff"
    type :backport
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
