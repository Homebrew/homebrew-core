class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.11.1.tar.gz"
  sha256 "5ac80927fc1359ccaaf225a638b8b7202e491ef65370c00e5c11580d40c8ca7f"

  bottle do
    sha256 "a3225af78505c11b0cc993a7125b1e497850cec6c8e28067410b9233aa58b509" => :mojave
    sha256 "74b4bc7df826ae826dd63f67425cd6d25103ae3ed962e060a49bcc9b5f389f70" => :high_sierra
    sha256 "02a508ff4a58f075d1f911366685fe29de456a26e31e283171a0160152fd3f63" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
