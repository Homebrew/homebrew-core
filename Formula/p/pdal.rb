class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.8.4/PDAL-2.8.4-src.tar.bz2"
  sha256 "c27dc79af0b26f9cb3209b694703e9d576f1b0c8c05b36206fd5e310494e75b5"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd95047f6de4b38a442111118ce2919521f8f2a16e5ab10b852ba2393e8a7492"
    sha256 cellar: :any,                 arm64_sonoma:  "8c728e287001a7ac379b008d61ab69a6cc386c400c76c1d4213081554a80928f"
    sha256 cellar: :any,                 arm64_ventura: "b0c76a50476b61a65383d23a5eab04d0ef440dd13ec21897f9c4fa98a91a72e6"
    sha256 cellar: :any,                 sonoma:        "211bab94d8693306e418561c117a4c782bd874d458d2de73b29803216f029207"
    sha256 cellar: :any,                 ventura:       "e474576399ed86e49ec9eed7cb8e8f565fa1d18b678e75fcc38bae8992640c6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bb4aa5c9df6dec9ffcb65674eb1d402ed72802754c1be2f892072f5ee9ff238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d4645ee0ea9b43b2694f9b6c8ea89481fa1bcaa62cc6269209fc04825bf748"
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
