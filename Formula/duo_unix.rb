class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.11.2.tar.gz"
  sha256 "e1ec2f43036ba639743d631f308419c9a88618a93d4038bf40a9cdeef89ca6db"
  revision 1

  bottle do
    sha256 "210721657888ee878f11a03497a9e5d8823410c4d0099b9aa33d03af4cce3b6e" => :mojave
    sha256 "bb736a12e115653d1eafb88221825101110cd9399e347241668027cf44b5ba44" => :high_sierra
    sha256 "dea30d4a4b5e20534aef3fca59001c58bed00dfd892adf458f9c417e73dee000" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
