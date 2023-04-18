class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/1.23.tar.gz"
  sha256 "9a37f8a6174f09bd622bc723b55881dc541cd50747cbd08831c2a82d620f6d76"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1d80f7684ef784f83b4f9312434a694c74e58351fd4eaab2641f6ef28bcda5ea"
    sha256 cellar: :any,                 arm64_monterey: "41f1ceea1e85dafe0552acf94a4903ef45fd54fc63e38c277b7d101c836e5801"
    sha256 cellar: :any,                 arm64_big_sur:  "377ac4b779d9ac24295b99c5f859dc8f78f473e62a90849f09eeec7a72d872d2"
    sha256 cellar: :any,                 ventura:        "4e5b8daba28db15b42a1a6d7c9f1bdc301906ca87889518522e7eb4ba0eb65f5"
    sha256 cellar: :any,                 monterey:       "3b4ce296ae8732cdec0b9fdc3623a5c12f8739b61c39cdb96be423e8004834be"
    sha256 cellar: :any,                 big_sur:        "bb5f8bc871e315e4ae36f011052f2b92e35040cc03ef8d448093e7be1bdfe6ac"
    sha256 cellar: :any,                 catalina:       "299f9004aa344b2ac164fdeee5a077c3e45335f3527cb8f2e67b46acf88b185a"
    sha256 cellar: :any,                 mojave:         "b4d54e51eef8d5d538830f555561fa4cc5f1b275b45588eae364d79de6b1d716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c056f3b6a5e2b25d90b57255138ce65796615d0e66d7156821b13ebbe8f836cd"
  end

  depends_on "cmake" => :build
  depends_on "gperftools"
  depends_on "snappy"

  def install
    args = *std_cmake_args + %W[
      -DLEVELDB_BUILD_TESTS=OFF
      -DLEVELDB_BUILD_BENCHMARKS=OFF
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    mkdir "build" do
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"
      bin.install "leveldbutil"

      system "make", "clean"
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libleveldb.a"
    end
  end

  test do
    assert_match "dump files", shell_output("#{bin}/leveldbutil 2>&1", 1)
  end
end
