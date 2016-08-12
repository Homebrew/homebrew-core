class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/v1.19.tar.gz"
  sha256 "7d7a14ae825e66aabeb156c1c3fae9f9a76d640ef6b40ede74cc73da937e5202"

  bottle do
    cellar :any
    sha256 "1d5edb51e88e13e185b0b43e01a2c1619fab8ccd25c6ae9ceb51cbc0be0f171d" => :el_capitan
    sha256 "c1a5a200e385a6a3def5bf1b0daa6fc8deab3c4678defd90bd56e2a494dc888c" => :yosemite
    sha256 "b5d3a94eb02f66c102af8ad1801326aebb0a15a97ebd3f1c070e947ed2c9a70f" => :mavericks
    sha256 "0b1b668e35556b43c0c95a0482209650551ae065451f8a9163d2c053a3af65a9" => :mountain_lion
  end

  option "with-test", "Verify the build with make check"

  depends_on "gperftools"
  depends_on "snappy"

  def install
    system "make"
    system "make", "check" if build.bottle? || build.with?("test")

    include.install "include/leveldb"
    bin.install "out-static/leveldbutil"
    lib.install "out-static/libleveldb.a"
    lib.install "out-shared/libleveldb.dylib.1.19" => "libleveldb.1.19.dylib"
    lib.install_symlink lib/"libleveldb.1.19.dylib" => "libleveldb.dylib"
    lib.install_symlink lib/"libleveldb.1.19.dylib" => "libleveldb.1.dylib"
    system "install_name_tool", "-id", "#{lib}/libleveldb.1.dylib", "#{lib}/libleveldb.1.19.dylib"
  end

  test do
    assert_match "dump files", shell_output("#{bin}/leveldbutil 2>&1", 1)
  end
end
