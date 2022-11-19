class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-2.0.0.tar.gz"
  sha256 "d1c761ce63eee0c35a57fc6b966096cac1fd52c9387c6112c6e56ec51ee1990b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "0794c8306c76cabc0d28c5aa741716ade8b41c8aa57c418a87ad28b220175cf5"
    sha256 arm64_monterey: "503e373bf79ad3480915f286b62c36fd7d36721e8773806db9655bed15c2a5a7"
    sha256 arm64_big_sur:  "505dab77dadca8ac5895dfbd6c09b5c57f798879245a5c8d305d6e54e6407438"
    sha256 monterey:       "55eda86b76dfa6a81d659b0478c551e0f3a4f5fc48eff968b51e1aa796c022dc"
    sha256 big_sur:        "ff0805bda43ec032f21bcd3fc59d6203bd04b2f1d5f6759cfa13c340a35ad475"
    sha256 catalina:       "230c609ac862446cf6d9c732c30484ec6b3f2ab46943d98f4d69b268a47249f9"
    sha256 x86_64_linux:   "6fb2b8c7785c401e441284bc6256d60e2808792713571648821426a75d84e9d6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
