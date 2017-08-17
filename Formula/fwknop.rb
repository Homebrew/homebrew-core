class Fwknop < Formula
  desc "Single Packet Authorization and Port Knocking"
  homepage "https://www.cipherdyne.org/fwknop/"
  url "https://github.com/mrash/fwknop/archive/2.6.9.tar.gz"
  sha256 "0a8de8d3e2073ad08f5834d39def6c33fd035809cfddbea252174e7dc06a5a51"
  revision 1
  head "https://github.com/mrash/fwknop.git"

  bottle do
    sha256 "0390ca5157954b4164b4a8a44cb2eb5597dd7484f5d695f8de9dc49b72b91100" => :sierra
    sha256 "2f8d98dd236580ebd7f6cca2403e53db8acd511342b74c8ef9842fd2c85607bc" => :el_capitan
    sha256 "d90d2292079429ba8165998ddec8ab6232391ce45ac477d7134109d8de5a0fc9" => :yosemite
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
                          "--with-gpg=#{Formula["gnupg"].opt_bin}/gpg"
    system "make", "install"
  end

  test do
    touch testpath/".fwknoprc"
    chmod 0600, testpath/".fwknoprc"
    system "#{bin}/fwknop", "--version"
  end
end
