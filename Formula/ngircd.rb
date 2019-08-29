class Ngircd < Formula
  desc "Lightweight Internet Relay Chat server"
  homepage "https://ngircd.barton.de/"
  url "https://ngircd.barton.de/pub/ngircd/ngircd-25.tar.gz"
  mirror "https://ngircd.sourceforge.io/pub/ngircd/ngircd-25.tar.gz"
  sha256 "51915780519bae43da3798807e3bed60d887e4eaa728354aa6bb61cdbcda49ba"
  revision 1

  bottle do
    sha256 "d73567d2f8a5282f0043b9ae86bc3742f3a31769c6659b05f5e689648f9f7c53" => :mojave
    sha256 "74c6d973c3a1ace3f1337732099cec0969731796f5e4f2edeb53cd216b3243c8" => :high_sierra
    sha256 "c7e2df47d407ffae865897036c0cb825d6b0105b0a85ded05c0deafbeade3d28" => :sierra
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
