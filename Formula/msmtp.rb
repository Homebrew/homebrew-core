class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "http://msmtp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.6.5/msmtp-1.6.5.tar.xz"
  sha256 "76a0d60693c7e65d0c7a12f01d300882d280b1e1be0202f54730ae44d44a5006"

  bottle do
    sha256 "6d1eef02a990fc1355f9d47da7237870d43ce0b5d24cb30a45c15952fdd815c4" => :el_capitan
    sha256 "d006ac74d71d76fb5c1881513c8204408c88863f38f37c5d2c1face8c7aeadfd" => :yosemite
    sha256 "a87c7d5ee59c48fdb1151cca93acea417db67f17cde2994ad97c2b0ee43722e3" => :mavericks
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
