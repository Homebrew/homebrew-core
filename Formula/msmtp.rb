class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "http://msmtp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.6.5/msmtp-1.6.5.tar.xz"
  sha256 "76a0d60693c7e65d0c7a12f01d300882d280b1e1be0202f54730ae44d44a5006"

  bottle do
    sha256 "587b8765d86f2b497bbb081ac4532d274e89d9e4ebd0a3917a798c67e921d712" => :el_capitan
    sha256 "5605ee05b8922d12d228c271cb3e8df87c2294cccc083501f19ea5316e19e539" => :yosemite
    sha256 "fc48e443dfe5c98f3ca5d40e66e05b6def31b06f17927d5743ea9906fc228775" => :mavericks
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
    (share/"msmtp/scripts").install "scripts/msmtpq"
  end
end
