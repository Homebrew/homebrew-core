class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.8.3/PDAL-2.8.3-src.tar.bz2"
  sha256 "13dfdb0d634bdd568b351fd535aaa03f7611df4c2cdb8be938117751355ad09b"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "26d1d4ed1b031144b62268a9c0f74cf36f9ecbf7e27a3f5fa0ef75a4e6c9f091"
    sha256 cellar: :any,                 arm64_sonoma:  "56fbea7788025185698ee4cf03b968680d74eff15642699377e4d173f5fff98d"
    sha256 cellar: :any,                 arm64_ventura: "2fd2da8d217867eb5352d55ed8c57e3eda314701ff1e1f6e52d73209eedd08d3"
    sha256 cellar: :any,                 sonoma:        "325e064a1414f52472476b7d2e2995a0d1ce9aec1837bbb566d457e57350f1dd"
    sha256 cellar: :any,                 ventura:       "20e92ec713b9ff101f8d2a7825a712da679b7d90370ee4d063dee8a92a7011df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8018c396ed11230df80026163d5170818d45f94d3ada48a1248610c642af3933"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libgeotiff"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "proj"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  def install
    args = %w[
      -DWITH_LASZIP=TRUE
      -DBUILD_PLUGIN_GREYHOUND=ON
      -DBUILD_PLUGIN_ICEBRIDGE=ON
      -DBUILD_PLUGIN_PGPOINTCLOUD=ON
      -DBUILD_PLUGIN_PYTHON=ON
      -DBUILD_PLUGIN_SQLITE=ON
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
