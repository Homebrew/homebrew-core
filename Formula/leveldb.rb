class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/1.21.tar.gz"
  sha256 "e0fbd238047b9e82ec26a2b808f826b60e12b4fcb5d1a18c7b3d6edf357b4026"

  bottle do
    cellar :any
    sha256 "207163a92d342b49859dadedc6c1dd521818291021320296842b96c596b09a78" => :mojave
    sha256 "25edbb2764d6e1fe3bd2f77abac191e94c088cda24540e218788672a88086df7" => :high_sierra
    sha256 "0c03715dd2161d3860552d660e06cf9a276bb8b412c332bfdb0449ea34030799" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gperftools"
  depends_on "snappy"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"
      bin.install "leveldbutil"

      system "make", "clean"
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libleveldb.a"
    end
  end

  test do
    assert_match "dump files", shell_output("#{bin}/leveldbutil 2>&1", 1)
  end
end
