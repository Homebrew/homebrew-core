class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.11.tar.xz"
  sha256 "f25f0fa177ce9e0ad65c127e790a37f35fb64fee9e33d90345844c5c86780e60"

  bottle do
    sha256 "ae5634512b5c69936c1755b182d8eafccca28005d28f4f7d8b41d074f64da66f" => :catalina
    sha256 "813d8e19745ad1642d69203d1d977ab124bf32e612220834a04ddd5086219308" => :mojave
    sha256 "d1d3b8b75826e109a521575b4b09d6690d34f73f488b8cca1c34f4c33c97b582" => :high_sierra
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
