class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.3.tar.xz"
  sha256 "3cb2eefd33d048f0f82de100ef39a494e44fd1485e376ead31f733d2f36b92b4"

  bottle do
    cellar :any
    sha256 "8f000e06393136dfd7cf68924553830fab4a95623da7b8ff5f52686589f8801f" => :mojave
    sha256 "ea6cc54b88d23cbadd34ded0901fdcf7cd29714b6fef6ec6ee2e17b1f910010c" => :high_sierra
    sha256 "ed0b8ff971d26c40e625ab45f30835fe05d340cbea9fbe3cdbc347c3a6e7144b" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --with-macosx-keyring
      --prefix=#{prefix}
      --with-tls=openssl
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
