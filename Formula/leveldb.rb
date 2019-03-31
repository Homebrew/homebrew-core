class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/1.21.tar.gz"
  sha256 "e0fbd238047b9e82ec26a2b808f826b60e12b4fcb5d1a18c7b3d6edf357b4026"

  bottle do
    cellar :any
    sha256 "0878e6a22d6c0738811874a4e305620e3179361017796bda9a08ed6a4a06f7bb" => :mojave
    sha256 "e033753dfe79996691998e974bef0cb3e468de581e5e005a06961144c47d2717" => :high_sierra
    sha256 "8528df5b2af7fab91b1ab1a6382f1b6ccd6d62da462c6a309cb76660a7225b4b" => :sierra
    sha256 "360b7c40470a5e3a4d4d7759983d310257be68d3e79518dbf71896a13093c6d0" => :el_capitan
    sha256 "5743bd58aa63406f6405d690fad63fff92169de51331ef6918310dcb70ad6383" => :yosemite
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
