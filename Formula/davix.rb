class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_3/davix-0.8.3.tar.gz"
  sha256 "7e30b5541e08d32dbf5ae03c6bcabeaec063aec10a6647787822227b4541ae3e"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6c59ee85fc7cb668ecbf170a3bac4a258e8be44ec3bf889d052b994bd28d3fac"
    sha256 cellar: :any,                 arm64_monterey: "aa25fb42dcca1ac2ad69f5ee1a7d0ab84c5df70a2c4036907c33bf3739b8eaf3"
    sha256 cellar: :any,                 arm64_big_sur:  "95d327e7cfb9dfaa8dc0e5785f58010ba3dfcd8bba0904d9fdc3e19ea5dba38c"
    sha256 cellar: :any,                 ventura:        "3dc5cd658130748d7182fb6f54b79280104595ce5eb55bfdc659ce6e40f2af14"
    sha256 cellar: :any,                 monterey:       "3ee908b44c9f4ecb035f409890a07ef4cc7f41365275c0bf62285cbb0784c0a7"
    sha256 cellar: :any,                 big_sur:        "554bfac4c2a799861a26fcd84bfee238856d0a06864c072ca9fd49522b53855d"
    sha256 cellar: :any,                 catalina:       "cc2d389eb2106de7c749c992097b5165cbcb07c96d97cd9946225c169b4c02d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00ec4568fca3c977e10e1aedc631db16fc2ccb33d9a401a561aa250922e9fbf4"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@1.1"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # needs CURLE_AUTH_ERROR, available since curl 7.66.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = std_cmake_args + %W[
      -DEMBEDDED_LIBCURL=FALSE
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIB_SUFFIX=
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/davix-get", "https://brew.sh"
  end
end
