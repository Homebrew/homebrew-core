class Ngircd < Formula
  desc "Lightweight Internet Relay Chat server"
  homepage "https://ngircd.barton.de/"
  url "https://ngircd.barton.de/pub/ngircd/ngircd-26.1.tar.xz"
  mirror "https://ngircd.sourceforge.io/pub/ngircd/ngircd-26.1.tar.xz"
  sha256 "55c16fd26009f6fc6a007df4efac87a02e122f680612cda1ce26e17a18d86254"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "9fe092e3ca8de75453b4aa667067e1cd863c041b8055ae7981e51f3506ac19c4" => :big_sur
    sha256 "95f504faeffb209318e93a050c632805178e91cd1e9475bbccfa9eb040b8d785" => :catalina
    sha256 "af9fea8f344f76077063b24d68d057bb9ecb93db1fb469d2e0992d0919f87b0c" => :mojave
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
