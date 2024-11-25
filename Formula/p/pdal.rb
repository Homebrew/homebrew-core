class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.8.1/PDAL-2.8.1-src.tar.bz2"
  sha256 "0e8d7deabe721f806b275dda6cf5630a8e43dc7210299b57c91f46fadcc34b31"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ace63b345d073dff970808b106404c6948a3c11d485809811ca1b7688d3e63c"
    sha256 cellar: :any,                 arm64_sonoma:  "3c902d2284736cb833b7df51a6aebfdbc287106cb083b99eff902217da069cff"
    sha256 cellar: :any,                 arm64_ventura: "6ed67bc6d48660119474b32a6619767d2773b596b8d532abfb47e66c0a667402"
    sha256 cellar: :any,                 sonoma:        "d32e2895b2ded2584177286909dc4610de3966ed88f0f55f496bcdf7bcc6480a"
    sha256 cellar: :any,                 ventura:       "445cd7662377535b2edc3a4c7ac45c454256d09c7b03187e724c644c837202fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a388ac898e825428521848a1a71c3bd92e25132b250040bdd7def926e9ebe96f"
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
