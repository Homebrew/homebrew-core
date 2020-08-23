class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.11.tar.xz"
  sha256 "f25f0fa177ce9e0ad65c127e790a37f35fb64fee9e33d90345844c5c86780e60"
  license "GPL-3.0"

  bottle do
    sha256 "465356913ededba9a76ab0f76f597913a3e7eb5901f47780494e140917a94447" => :catalina
    sha256 "8ce3ca882b2e0fbc6bad2fdf544f20f53413616bda869544f90c51e9bd87a521" => :mojave
    sha256 "61d5d5c532afb5f5297ccd3e5d2e7ba09b3810f8b128701160c981e6c16fc73e" => :high_sierra
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
