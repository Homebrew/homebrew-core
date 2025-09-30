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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "8cc990504a450685d677e758cf6741b058dd5b82e1ddf2f10c1e70bac003d58a"
    sha256 arm64_sequoia:  "b355d6e9d840dd066aa4e71bbc2b4ebcca2f13741b07153fcc91a159b0d1665c"
    sha256 arm64_sonoma:   "f5a84ad8458393c0dea21c9e640de968ae3184ddfcf0cf3f25136d376622d564"
    sha256 arm64_ventura:  "847f22724b3cd9e0fe820e25fdf778e5190f347b2bba2b81fda5753dacf44d67"
    sha256 arm64_monterey: "40c22caf4823f43a2014c73f4ef86a2f6556107c2e5752975ddbf1924c9bc80c"
    sha256 arm64_big_sur:  "a849ec13147c5cb08b03376eae868b6c82ec075a60388bf7e6742fbb9f56b467"
    sha256 sonoma:         "4c4dff477fde71d015a7ba53c377fcdbc88e31a7e3b430597da5b15a4138d3ba"
    sha256 ventura:        "b362fccb77368d232684efe3895ae60b0f686869c677a3815c016a2dd46dc03c"
    sha256 monterey:       "7002fcd03b711f7dbefacd3287435d2ec4fbf96f6410dcefc1fb0d36bc3a2f25"
    sha256 big_sur:        "80d655556c77aeb341dd0fc52d70e61dfd8a3518cf689bcb68af6f0aacc04bd5"
    sha256 catalina:       "9a95027d4121667ec569d3aac52ec540a0aacd393e584b503aae73f35808ab0d"
    sha256 arm64_linux:    "16be2c0b756f68f456251052c96ac4436e92a96be74ff9c0e2d935be95bd2e62"
    sha256 x86_64_linux:   "9ef3f4d6acb641cbe910f05f8ec191ffdc886b80c1bed89a962a27031071a940"
  end

  depends_on "readline"
  depends_on "sqlite"

  def install
    ENV.cxx11

    # Reported upstream: http://bugs.linuxnetworks.de/index.php?do=details&id=40
    inreplace "utils/Makefile.in", "$(LIBSUFFIX)", ".dylib" if OS.mac?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--with-backends=sqlite3", *args, *std_configure_args
    system "make", "install"
  end

  test do
    testfile = testpath/"test.sql"
    testfile.write <<~SQL
      create table t(x);
      insert into t values("Hello");
      .header
      select * from t;
      .quit
    SQL

    assert_match '"Hello"',
      pipe_output("#{bin}/odbx-sql odbx-sql -h ./ -d test.sqlite3 -b sqlite3", (testpath/"test.sql").read)
  end
end
