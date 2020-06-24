class Ngircd < Formula
  desc "Lightweight Internet Relay Chat server"
  homepage "https://ngircd.barton.de/"
  url "https://ngircd.barton.de/pub/ngircd/ngircd-26.tar.gz"
  mirror "http://ngircd.sourceforge.net/pub/ngircd/ngircd-26.tar.gz"
  sha256 "128441256c489f67a63c6d8459b97f0106959526ccd70b513eba2508dfbac651"

  bottle do
    sha256 "ab560382241371099b6dd976be87d317c806ae26373d326e0bb3e3dd3fad0458" => :catalina
    sha256 "b0cd1030229d21b7c8f7d100e26f83c4c201741f796d6df48c8ba628d2c69b41" => :mojave
    sha256 "6c3ccfd94aa2ad7a24354ada84b40f34ee1891a3130cd0987f2e7139f0187b84" => :high_sierra
  end

  depends_on "libident"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

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
