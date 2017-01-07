class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "http://msmtp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.6.6/msmtp-1.6.6.tar.xz"
  sha256 "da15db1f62bd0201fce5310adb89c86188be91cd745b7cb3b62b81a501e7fb5e"

  bottle do
    sha256 "d0b8a2a76d7ee8ed6beda0c383acd28d7a85d9d677c8d89a8a2e6b717055fe70" => :sierra
    sha256 "115ce90fcc11a1fbda6bf4496200b50e89d4cccdb32f999cf6b3b749635f8e3e" => :el_capitan
    sha256 "6f5227576bf8ac42fed7190c22f2e62b0fb2a3af59fa085e783426661c606758" => :yosemite
  end

  option "with-gsasl", "Use GNU SASL authentication library"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "gsasl" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --with-macosx-keyring
      --prefix=#{prefix}
      --with-tls=openssl
    ]

    args << "--with-libsasl" if build.with? "gsasl"

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end
end
