class Opendbx < Formula
  desc "Lightweight but extensible database access library in C"
  homepage "https://linuxnetworks.de/doc/index.php/OpenDBX"
  url "https://linuxnetworks.de/opendbx/download/opendbx-1.4.6.tar.gz"
  sha256 "2246a03812c7d90f10194ad01c2213a7646e383000a800277c6fb8d2bf81497c"
  license "LGPL-2.0-or-later"
  revision 2

  # The download page includes a `libopendbx` development release, so we use a
  # leading forward slash to only match `opendbx` versions.
  livecheck do
    url "https://linuxnetworks.de/doc/index.php?title=OpenDBX/Download"
    regex(%r{href=.*?/opendbx[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "847f22724b3cd9e0fe820e25fdf778e5190f347b2bba2b81fda5753dacf44d67"
    sha256 arm64_monterey: "40c22caf4823f43a2014c73f4ef86a2f6556107c2e5752975ddbf1924c9bc80c"
    sha256 arm64_big_sur:  "a849ec13147c5cb08b03376eae868b6c82ec075a60388bf7e6742fbb9f56b467"
    sha256 ventura:        "b362fccb77368d232684efe3895ae60b0f686869c677a3815c016a2dd46dc03c"
    sha256 monterey:       "7002fcd03b711f7dbefacd3287435d2ec4fbf96f6410dcefc1fb0d36bc3a2f25"
    sha256 big_sur:        "80d655556c77aeb341dd0fc52d70e61dfd8a3518cf689bcb68af6f0aacc04bd5"
    sha256 catalina:       "9a95027d4121667ec569d3aac52ec540a0aacd393e584b503aae73f35808ab0d"
    sha256 mojave:         "9f4ed6175131681d7aa68a5cc62a3fab535f428f05982873c756d534ce4a71f9"
    sha256 high_sierra:    "8acc7893f16018ca7946d5a087459f7defbaa3fa3a17759d9eec5eaaffd27458"
    sha256 sierra:         "4adab552ad5d1fca471ba71734b784de2d6005717cef6908c0e8366b217c4dd1"
    sha256 x86_64_linux:   "9ef3f4d6acb641cbe910f05f8ec191ffdc886b80c1bed89a962a27031071a940"
  end

  depends_on "readline"
  depends_on "sqlite"

  def install
    # Reported upstream: http://bugs.linuxnetworks.de/index.php?do=details&id=40
    inreplace "utils/Makefile.in", "$(LIBSUFFIX)", ".dylib" if OS.mac?

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

    assert_match '"Hello"',
      pipe_output("#{bin}/odbx-sql odbx-sql -h ./ -d test.sqlite3 -b sqlite3", (testpath/"test.sql").read)
  end
end
