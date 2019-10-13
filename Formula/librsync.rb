class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.2.0.tar.gz"
  sha256 "9eac82c09c4404ba4edadd25dbbcc14008e553c9b2fb492ff9ee05cad9fa012c"

  bottle do
    sha256 "b582a3cff68f50a4d42fcb4aa4bb9401514715ba02814945a7af0c95d56b6d24" => :catalina
    sha256 "addc0756351610330977decc0ae1b31c6f2928e527faef5d38230f623b88dc07" => :mojave
    sha256 "9e813729589ad923be1fd040cd54a5c5083a824c05f09f7f8a77fc529a9516ce" => :high_sierra
    sha256 "a4523e8193af9a30986f706d22d53b937d3ffc9c1bfa5fda05d54654a616a0ef" => :sierra
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
