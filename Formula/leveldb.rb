class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/v1.20.tar.gz"
  sha256 "f5abe8b5b209c2f36560b75f32ce61412f39a2922f7045ae764a2c23335b6664"
  revision 2

  bottle do
    cellar :any
    sha256 "8528df5b2af7fab91b1ab1a6382f1b6ccd6d62da462c6a309cb76660a7225b4b" => :sierra
    sha256 "360b7c40470a5e3a4d4d7759983d310257be68d3e79518dbf71896a13093c6d0" => :el_capitan
    sha256 "5743bd58aa63406f6405d690fad63fff92169de51331ef6918310dcb70ad6383" => :yosemite
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
    lib.install "out-shared/libleveldb.dylib.1.20" => "libleveldb.1.20.dylib"
    lib.install_symlink lib/"libleveldb.1.20.dylib" => "libleveldb.dylib"
    lib.install_symlink lib/"libleveldb.1.20.dylib" => "libleveldb.1.dylib"
    MachO::Tools.change_dylib_id("#{lib}/libleveldb.1.dylib", "#{lib}/libleveldb.1.20.dylib")
  end

  test do
    assert_match "dump files", shell_output("#{bin}/leveldbutil 2>&1", 1)
  end
end
