class Opendbx < Formula
  desc "Lightweight but extensible database access library in C"
  homepage "https://linuxnetworks.de/doc/index.php/OpenDBX"
  url "https://linuxnetworks.de/opendbx/download/opendbx-1.4.6.tar.gz"
  sha256 "2246a03812c7d90f10194ad01c2213a7646e383000a800277c6fb8d2bf81497c"
  revision 1

  bottle do
    sha256 "a98f96a0a70e29bba16f505dc13ea7638ef82ec398de40d6430eced24afbb4c9" => :mojave
    sha256 "42ed70ef4eb93be7351b5d66ff131ad13cb92290d9dee6a721d9050ae3a187cd" => :high_sierra
    sha256 "275e19f854b29f8d1d0560a4cca55395854312d678c5c64ad3c2597df7569aef" => :sierra
    sha256 "84a0f694107dd4d15b949dd68474e5a270da583058b7eff29688370ef3a8e18f" => :el_capitan
    sha256 "874a8b0ef941eec827bd85e59b7773269bb6b3632e38b9d192a003c4134b3227" => :yosemite
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
