class Ngircd < Formula
  desc "Lightweight Internet Relay Chat server"
  homepage "https://ngircd.barton.de/"
  url "https://ngircd.barton.de/pub/ngircd/ngircd-26.tar.gz"
  mirror "http://ngircd.sourceforge.net/pub/ngircd/ngircd-26.tar.gz"
  sha256 "128441256c489f67a63c6d8459b97f0106959526ccd70b513eba2508dfbac651"

  bottle do
    rebuild 1
    sha256 "129bf331b86f1d54735cf773a36b402323af0667afc1e2a1da4554899d05e8e3" => :catalina
    sha256 "7fdce95437555b6de33aa1b0c9d3e3441405b5d3c9ec2f728a7b28f35983402d" => :mojave
    sha256 "b58cacea0c009487e46b48d7220623001e49ad31722704ee805fd7029313f5d6" => :high_sierra
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
