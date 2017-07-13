class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/v1.20.tar.gz"
  sha256 "f5abe8b5b209c2f36560b75f32ce61412f39a2922f7045ae764a2c23335b6664"
  revision 2

  bottle do
    cellar :any
    sha256 "ef37df5779b602f28adf5937fe890a5969236132e2a47929846d3e16503dc878" => :sierra
    sha256 "abbc5a2eb45c96d2c41a2e18bc3830cbf73056e543e954cf9b133e81efb89363" => :el_capitan
    sha256 "c807f88850c2a9d476252bc197f6310ff9a0f60436ac78a5fc037d6ee83db71a" => :yosemite
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
