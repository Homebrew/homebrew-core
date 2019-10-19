class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.2.1.tar.gz"
  sha256 "b5ab8e2092b82b7d7bb9c1dd52e6a77083a89f8ad9b9309da611f490d0b49a71"

  bottle do
    sha256 "b9b3afb3ec1694152e3c0bd32044d3a6fedae7143837004ce3ebb6dd4350c4a5" => :catalina
    sha256 "18e5e0e833f9ce29038c02bf88f08e05bb319d0e52b9a28da2f7dac5931076d6" => :mojave
    sha256 "4e58b9ce861bd356f6626e7e8d2b0e6b80d4c0f54387c51adab6561a41c873a6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man1.install "doc/rdiff.1"
    man3.install "doc/librsync.3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdiff -V")
  end
end
