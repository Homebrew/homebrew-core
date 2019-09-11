class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.5.tar.xz"
  sha256 "1613daced9c47b8c028224fc076799c2a4d72923e242be4e9e5c984cbbbb9f39"

  bottle do
    cellar :any
    sha256 "b565cc6011abc3d4491ce6e35362dd97297bcce3d6694cba7bc20bcc756d6738" => :mojave
    sha256 "cd32f619d3b85794bc62b2374ca2ee9874014c2d31b609f34af437311ad2f028" => :high_sierra
    sha256 "a2008bd10e0465b0a165810000c18bf1a8a25d3de154ed2fbe0206b70ce5fb1f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-macosx-keyring
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
