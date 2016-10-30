class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/v1.19.tar.gz"
  sha256 "7d7a14ae825e66aabeb156c1c3fae9f9a76d640ef6b40ede74cc73da937e5202"

  bottle do
    cellar :any
    sha256 "688768ac09d7b8facf8e76f12f42482ed1a58323a7067a087705b276ea9aabf0" => :sierra
    sha256 "a1cd94640590b34d997f4fc68fda303785c3087a592504500f5110b23cd91c85" => :el_capitan
    sha256 "a3c1d90348b005180c3c83c9d1180dea206b37b8f50f53725f63955552bd8485" => :yosemite
    sha256 "3de4411766fb99c683ab13e49dd6d788f7193c388b7e244b3b8868b9e23c4cdb" => :mavericks
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
