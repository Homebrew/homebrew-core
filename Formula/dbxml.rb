class Dbxml < Formula
  desc "Embeddable XML database with XQuery support and other advanced features"
  homepage "https://www.oracle.com/database/berkeley-db/xml.html"
  url "https://download.oracle.com/berkeley-db/dbxml-6.1.4.tar.gz"
  sha256 "a8fc8f5e0c3b6e42741fa4dfc3b878c982ff8f5e5f14843f6a7e20d22e64251a"
  revision 3

  bottle do
    sha256 "07c27c56727cc3dca11bf121ce847147283aac32d53afb7a3e435447875393df" => :high_sierra
    sha256 "2ab017cc9994d62a4e343160755e0d178b2a8235e121cd55fe2ca50126c9496c" => :sierra
    sha256 "7fec645fd2d90e159c8346775b5d012edb4ccfc1a378189723f3f2250331b01e" => :el_capitan
  end

  depends_on "xerces-c"
  depends_on "xqilla"
  depends_on "berkeley-db"

  needs :cxx11

  # No public bug tracker or mailing list to submit this to, unfortunately.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/dbxml/c%2B%2B11.patch"
    sha256 "98d518934072d86c15780f10ceee493ca34bba5bc788fd9db1981a78234b0dc4"
  end

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
