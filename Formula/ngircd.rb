class Ngircd < Formula
  desc "Next generation IRC daemon"
  homepage "https://ngircd.barton.de/"
  url "https://ngircd.barton.de/pub/ngircd/ngircd-24.tar.gz"
  mirror "https://ngircd.mirror.3rz.org/pub/ngircd/ngircd-24.tar.gz"
  sha256 "3e00a7da52c81fc1e02bb996a27bf43da905ba7037bf8c6bb3bd13321e0c85ab"

  bottle do
    sha256 "f7bd9059bc934e317cda8491cc6ed08c1a86da0da8e52a1424842892ce03a45b" => :mojave
    sha256 "6832dfa5480e2f089c32468c14eaa0a4d2ef3a1945eb53b1544068c2957fecd2" => :high_sierra
    sha256 "a5303a11814a311d639f585645808f9378b660982c5e40f4c8d025353d35001b" => :sierra
    sha256 "761f7fdf0da86e1926cfe17ed298610cd1eb20607232ea1b75cc4f14c1966ae0" => :el_capitan
    sha256 "678de9420c8bd5661ec0a6c9418539684a874298c1b35a99684368aac365d2e2" => :yosemite
  end

  depends_on "libident"
  depends_on "openssl"

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
