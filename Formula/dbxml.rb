class Dbxml < Formula
  desc "Embeddable XML database with XQuery support and other advanced features"
  homepage "https://www.oracle.com/us/products/database/berkeley-db/xml/overview/index.html"
  url "http://download.oracle.com/berkeley-db/dbxml-6.1.4.tar.gz"
  sha256 "a8fc8f5e0c3b6e42741fa4dfc3b878c982ff8f5e5f14843f6a7e20d22e64251a"

  bottle do
    rebuild 1
    sha256 "669e6aadc43f46b060eb2acadd214dae28b5b6727d46e18c4e302d81665f2170" => :sierra
    sha256 "402542ead71ef0b095bca06052270709a1302dca5ae4d2202c23e6457e83fd77" => :el_capitan
    sha256 "a055bb860d3059aebe23029e14a4fe58fb6ad1a586864f1c74dc51970cfdc432" => :yosemite
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
