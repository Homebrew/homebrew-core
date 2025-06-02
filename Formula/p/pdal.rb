class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.8.4/PDAL-2.8.4-src.tar.bz2"
  sha256 "c27dc79af0b26f9cb3209b694703e9d576f1b0c8c05b36206fd5e310494e75b5"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "64bb0d0e90ce547231899e349d64126c75c9a89e4564e57ede59eeca6c654e5e"
    sha256 cellar: :any,                 arm64_sonoma:  "6b051c39b6bb6c691cc76aca04fd53191515ac9ae64971185f601f5dfadbe32c"
    sha256 cellar: :any,                 arm64_ventura: "7b44dbcbfdfac6af9dcf1d59f2cc37182224638c5289fc16374c465aae0a415b"
    sha256 cellar: :any,                 sonoma:        "4bc10dded0e56135067113caa32b25833dda96c80bb14673b840952b58e85f29"
    sha256 cellar: :any,                 ventura:       "725b858faef46f66946bc1e29ae644bef8f42c71295196a070bec68ec6222de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be97476fd1203ef225f9aa71469adac4aac70314af62aafe9abf8921e812f32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e28a8d44c02b9f638c76824ad8a17a90cbb9f806bf4b5aba66a49a29ee91738b"
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
