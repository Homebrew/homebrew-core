class Opendbx < Formula
  desc "Lightweight but extensible database access library in C"
  homepage "https://linuxnetworks.de/doc/index.php/OpenDBX"
  url "https://linuxnetworks.de/opendbx/download/opendbx-1.4.6.tar.gz"
  sha256 "2246a03812c7d90f10194ad01c2213a7646e383000a800277c6fb8d2bf81497c"
  revision 2

  bottle do
    sha256 "9a95027d4121667ec569d3aac52ec540a0aacd393e584b503aae73f35808ab0d" => :catalina
    sha256 "9f4ed6175131681d7aa68a5cc62a3fab535f428f05982873c756d534ce4a71f9" => :mojave
    sha256 "8acc7893f16018ca7946d5a087459f7defbaa3fa3a17759d9eec5eaaffd27458" => :high_sierra
    sha256 "4adab552ad5d1fca471ba71734b784de2d6005717cef6908c0e8366b217c4dd1" => :sierra
  end

  depends_on "readline"
  depends_on "sqlite"

  def install
    # Reported upstream: http://bugs.linuxnetworks.de/index.php?do=details&id=40
    inreplace "utils/Makefile.in", "$(LIBSUFFIX)", ".dylib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-backends=sqlite3"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"test.sql"
    testfile.write <<~EOS
      create table t(x);
      insert into t values("Hello");
      .header
      select * from t;
      .quit
    EOS

    assert_match /"Hello"/,
      shell_output("#{bin}/odbx-sql odbx-sql -h ./ -d test.sqlite3 -b sqlite3 < #{testpath}/test.sql")
  end
end
