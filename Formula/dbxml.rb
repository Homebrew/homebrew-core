class Dbxml < Formula
  desc "Embeddable XML database with XQuery support and other advanced features"
  homepage "https://www.oracle.com/us/products/database/berkeley-db/xml/overview/index.html"
  url "http://download.oracle.com/berkeley-db/dbxml-6.1.4.tar.gz"
  sha256 "a8fc8f5e0c3b6e42741fa4dfc3b878c982ff8f5e5f14843f6a7e20d22e64251a"

  bottle do
    sha256 "a471d0f7df2e846a3eee974b29d33e48185e45ec49791552f034d0b4c7f28fdd" => :sierra
    sha256 "bf89aad9e0c5341a69f45041044f4a87f73c469973c4c039f105c5af2d30c9fd" => :el_capitan
    sha256 "8fe99043112262ad2575e3624b2755147a474d7abce7369624b2746932a212af" => :yosemite
  end

  depends_on "xerces-c"
  depends_on "xqilla"
  depends_on "berkeley-db"

  def install
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
    (testpath/"simple.xml").write <<-EOS.undent
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

    (testpath/"dbxml.script").write <<-EOS.undent
      createContainer ""
      putDocument simple "simple.xml" f
      cquery 'sum(//food/calories)'
      print
      quit
    EOS
    assert_equal "1600", shell_output("#{bin}/dbxml -s #{testpath}/dbxml.script").chomp
  end
end
