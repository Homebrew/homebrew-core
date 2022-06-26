class Ngircd < Formula
  desc "Lightweight Internet Relay Chat server"
  homepage "https://ngircd.barton.de/"
  url "https://ngircd.barton.de/pub/ngircd/ngircd-26.1.tar.xz"
  mirror "https://ngircd.sourceforge.io/pub/ngircd/ngircd-26.1.tar.xz"
  sha256 "55c16fd26009f6fc6a007df4efac87a02e122f680612cda1ce26e17a18d86254"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ngircd.barton.de/download.php"
    regex(/href=.*?ngircd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 monterey:     "7939168fb5b5936e1acf6f9a9729ed98d4ea1f8bde061b46ab926eec219a2db1"
    sha256 big_sur:      "9fe092e3ca8de75453b4aa667067e1cd863c041b8055ae7981e51f3506ac19c4"
    sha256 catalina:     "95f504faeffb209318e93a050c632805178e91cd1e9475bbccfa9eb040b8d785"
    sha256 mojave:       "af9fea8f344f76077063b24d68d057bb9ecb93db1fb469d2e0992d0919f87b0c"
    sha256 x86_64_linux: "162378420b96b05babe0deb07fd568a719970b3737313aeb79b048d0c72ecff6"
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

    if OS.mac?
      prefix.install "contrib/MacOSX/de.barton.ngircd.plist.tmpl" => "de.barton.ngircd.plist"
      (prefix/"de.barton.ngircd.plist").chmod 0644

      inreplace prefix/"de.barton.ngircd.plist" do |s|
        s.gsub! ":SBINDIR:", sbin
        s.gsub! "/Library/Logs/ngIRCd.log", var/"Logs/ngIRCd.log"
      end
    end
  end

  test do
    # Exits non-zero, so test version and match Author's name supplied.
    assert_match "Alexander", pipe_output("#{sbin}/ngircd -V 2>&1")
  end
end
