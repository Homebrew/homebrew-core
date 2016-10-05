class Fwknop < Formula
  desc "Single Packet Authorization and Port Knocking"
  homepage "https://www.cipherdyne.org/fwknop/"
  url "https://github.com/mrash/fwknop/archive/2.6.9.tar.gz"
  sha256 "0a8de8d3e2073ad08f5834d39def6c33fd035809cfddbea252174e7dc06a5a51"
  head "https://github.com/mrash/fwknop.git"

  bottle do
    sha256 "20da10e0cc1f53aa7c4126d28ab346313e8692d8d0c94fdb1e64da723e7ccd87" => :sierra
    sha256 "824bb998105739b7f0ea303f8721fdeb518a316760cf8e5328f5475ddac6b830" => :el_capitan
    sha256 "e288757e9d083dcf46f86ccb9cf5a6b3a847310821429715db08db9e2285d929" => :yosemite
    sha256 "d281d8667d92b2cfedbc8d19918c4b6a6f5b223c940b46678243d5ce6850f8c2" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "wget" => :optional
  depends_on "gpgme"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
                          "--prefix=#{prefix}", "--with-gpgme", "--sysconfdir=#{etc}",
                          "--with-gpg=#{Formula["gnupg2"].opt_bin}/gpg2"
    system "make", "install"
  end

  test do
    touch testpath/".fwknoprc"
    chmod 0600, testpath/".fwknoprc"
    system "#{bin}/fwknop", "--version"
  end
end
