class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.6.tar.xz"
  sha256 "6625f147430c65ba8527f52c4fe5d4d33552d3c0fb6d793ba7df819a3b3042e1"

  bottle do
    sha256 "b87279f1b03cb7d1c9aff6be8813d6a6a107cbc21a5daaace12d4e0e443108b4" => :catalina
    sha256 "20191005df5166b0b713d41ffbd342e5e680d4f7767a3d793f44103109cafe59" => :mojave
    sha256 "31c02f70d4a3f574069c1d87347de494f91846e9e24a90de3a9c28b7c35d14f6" => :high_sierra
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
