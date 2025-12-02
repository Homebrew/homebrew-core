class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/refs/tags/1.23.tar.gz"
  sha256 "9a37f8a6174f09bd622bc723b55881dc541cd50747cbd08831c2a82d620f6d76"
  license "BSD-3-Clause"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a3373ff147b1d86903e34ffbb189d010826bf7acfeae4de3481fabd01e156e4"
    sha256 cellar: :any,                 arm64_sequoia: "9ddcdcdaef16a4ecf52daefeea18623f769da2728bff6fcffff130ec130136e8"
    sha256 cellar: :any,                 arm64_sonoma:  "8ae60cb6aaa09c5508c3606a2f6666aaa12bafb44b56cbb262b5fdb0b7234e8d"
    sha256 cellar: :any,                 arm64_ventura: "c0970a965d039a1f3ad15c7db01b80b9e8851c59f63fe55f0eaa8633d083530c"
    sha256 cellar: :any,                 sonoma:        "5a757793bb447bf5a91ee7fc38864c7dd4d870f857324524a4bd016c767afdda"
    sha256 cellar: :any,                 ventura:       "b20dad4e906b5c65f7b52e4a61293c22b8324925b24c982c0c4baad2c77e13c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e65c084c1d96f275941227d504bf22bc4e8b0733d01658e7c5d6e0efc61a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff14a180346c9cece9aa3ddaaab5882eb6f9fa5074cde29d874ab640b351fed2"
  end

  depends_on "cmake" => :build
  depends_on "snappy"

  def install
    args = %W[
      -DLEVELDB_BUILD_TESTS=OFF
      -DLEVELDB_BUILD_BENCHMARKS=OFF
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build_shared",
                      *args, "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
    bin.install "build_shared/leveldbutil"

    system "cmake", "-S", ".", "-B", "build_static",
                      *args, "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_static/libleveldb.a"
  end

  test do
    assert_match "dump files", shell_output("#{bin}/leveldbutil 2>&1", 1)
  end
end
