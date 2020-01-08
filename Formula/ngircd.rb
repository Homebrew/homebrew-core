class Ngircd < Formula
  desc "Lightweight Internet Relay Chat server"
  homepage "https://ngircd.barton.de/"
  url "https://ngircd.barton.de/pub/ngircd/ngircd-25.tar.gz"
  mirror "https://ngircd.sourceforge.io/pub/ngircd/ngircd-25.tar.gz"
  sha256 "51915780519bae43da3798807e3bed60d887e4eaa728354aa6bb61cdbcda49ba"
  revision 1

  bottle do
    sha256 "19f2aae10f51901688ab282af2a5227d82c36ae4a3013661a56d823aae1c3868" => :catalina
    sha256 "0fd70a8662655bd45398d69f5ea38304baa96b84bc44980ba4ad6eebb6246f24" => :mojave
    sha256 "a85e43607f7e2a52fed2187508d1dbcf8dae25dae9e4704d58a76f3c751032a0" => :high_sierra
    sha256 "48e83fcdd8462a77cd8855ff1ca69fe17e4f6796e465dc5a3784e4653f59db54" => :sierra
  end

  depends_on "libident"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{HOMEBREW_PREFIX}/etc",
                          "--enable-ipv6",
                          "--with-ident",
                          "--with-openssl"
    system "make", "install"

    prefix.install "contrib/MacOSX/de.barton.ngircd.plist.tmpl" => "de.barton.ngircd.plist"
    (prefix+"de.barton.ngircd.plist").chmod 0644

    inreplace prefix+"de.barton.ngircd.plist" do |s|
      s.gsub! ":SBINDIR:", sbin
      s.gsub! "/Library/Logs/ngIRCd.log", var/"Logs/ngIRCd.log"
    end
  end

  test do
    # Exits non-zero, so test version and match Author's name supplied.
    assert_match /Alexander/, pipe_output("#{sbin}/ngircd -V 2>&1")
  end
end
