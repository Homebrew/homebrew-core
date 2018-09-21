class Dbxml < Formula
  desc "Embeddable XML database with XQuery support and other advanced features"
  homepage "https://www.oracle.com/database/berkeley-db/xml.html"
  url "https://download.oracle.com/berkeley-db/dbxml-6.1.4.tar.gz"
  sha256 "a8fc8f5e0c3b6e42741fa4dfc3b878c982ff8f5e5f14843f6a7e20d22e64251a"
  revision 3

  bottle do
    sha256 "b525b9d21d149d533aeb62a169becfe1e140f143d34291d0a8fddf2ada41a018" => :mojave
    sha256 "1886b654f152fc03a6a6e781ca94e5ca3a08f7f190bc1168326bf46b337c02e9" => :high_sierra
    sha256 "2a350300c31d639d46e9fafc16747d5cbe1897035acf1c365f795127535693b3" => :sierra
    sha256 "e2c82383d79f243654a0bbebdfb141334bbf683c6925b5a8f3ce0d1568024fec" => :el_capitan
  end

  depends_on "berkeley-db"
  depends_on "xerces-c"
  depends_on "xqilla"

  # No public bug tracker or mailing list to submit this to, unfortunately.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/dbxml/c%2B%2B11.patch"
    sha256 "98d518934072d86c15780f10ceee493ca34bba5bc788fd9db1981a78234b0dc4"
  end

  needs :cxx11

  def install
    ENV.cxx11

    inreplace "dbxml/configure" do |s|
      s.gsub! "lib/libdb-*.la | sed -e 's\/.*db-\\\(.*\\\).la", "lib/libdb-*.a | sed -e 's/.*db-\\(.*\\).a"
      s.gsub! "lib/libdb-*.la", "lib/libdb-*.a"
      s.gsub! "libz.a", "libz.dylib"
    end

    cd "dbxml" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-xqilla=#{Formula["xqilla"].opt_prefix}",
                            "--with-xerces=#{Formula["xerces-c"].opt_prefix}",
                            "--with-berkeleydb=#{Formula["berkeley-db"].opt_prefix}"
      system "make", "install"
    end
  end

  test do
    (testpath/"simple.xml").write <<~EOS
      <breakfast_menu>
        <food>
          <name>Belgian Waffles</name>
          <calories>650</calories>
        </food>
        <food>
          <name>Homestyle Breakfast</name>
          <calories>950</calories>
        </food>
      </breakfast_menu>
    EOS

    (testpath/"dbxml.script").write <<~EOS
      createContainer ""
      putDocument simple "simple.xml" f
      cquery 'sum(//food/calories)'
      print
      quit
    EOS
    assert_equal "1600", shell_output("#{bin}/dbxml -s #{testpath}/dbxml.script").chomp
  end
end
