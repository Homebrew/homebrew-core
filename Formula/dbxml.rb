class Dbxml < Formula
  desc "Embeddable XML database with XQuery support and other advanced features"
  homepage "https://www.oracle.com/us/products/database/berkeley-db/xml/overview/index.html"
  url "http://download.oracle.com/berkeley-db/dbxml-6.0.18.tar.gz"
  sha256 "5851f60a47920718b701752528a449f30b16ddbf5402a2a5e8cde8b4aecfabc8"
  revision 2

  bottle do
    cellar :any
    sha256 "b383921c02c9a882a7437a7a14097bfea4d19f2da6d0329e711bb71f1ec3f4d9" => :sierra
    sha256 "36a614a26a2fbdb0986c241fc93ed392455587cfa76756f0385718a80cf9f258" => :el_capitan
    sha256 "a543c8d175bb91bd3ae0bf20fe9c10c1ece60e20026effe8a3476f3728f9a7cf" => :yosemite
  end

  depends_on "xerces-c"
  depends_on "xqilla"
  depends_on "berkeley-db"

  def install
    inreplace "dbxml/configure" do |s|
      s.gsub! "lib/libdb-*.la | sed 's\/.*db-\\\(.*\\\).la", "lib/libdb-*.a | sed 's/.*db-\\(.*\\).a"
      s.gsub! "lib/libdb-*.la", "lib/libdb-*.a"
    end

    cd "dbxml" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-xqilla=#{HOMEBREW_PREFIX}",
                            "--with-xerces=#{HOMEBREW_PREFIX}",
                            "--with-berkeleydb=#{HOMEBREW_PREFIX}"
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
