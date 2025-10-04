class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.31.tar.xz"
  sha256 "c262b11762d8582a3c6d6ca8d8b2cca2b1605497324ca27cc57fdc145a27119f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b686be7fda6d731ca676842c9bc77494b5aaf609dd79752def7f8d651623f3dd"
    sha256 cellar: :any, arm64_sequoia: "63eed4d34a40306fae1029f3a6e7f1f72cc5177686b620577c42c2d6efa9e1ef"
    sha256 cellar: :any, arm64_sonoma:  "cfd986caacad5c5a535de055684861c6cdd5cf55becd1cb8a4ff15285f017f97"
    sha256 cellar: :any, arm64_ventura: "1a52f0f95089875b40abffa6b42659202da260f00216ba31230b067a2d11ba05"
    sha256 cellar: :any, sonoma:        "07fe7618912e51ef6f59acf7bd5b64c8c9381d2061173ee2535b00e087cfd447"
    sha256 cellar: :any, ventura:       "b3232cd95e942a3de3ead54bf7d03a3112840dcd7c59666db3a505a25b99387b"
    sha256               arm64_linux:   "7989647718bd6597160a12f439cc0446e1ff4594f6db275750cbe69ae29bd86e"
    sha256               x86_64_linux:  "f0ca8d09377e55b9c933afa3b52a8e9bbcb2d98f04cc47f41192efec61aa7ab9"
  end

  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", "--disable-silent-rules", "--with-macosx-keyring", *std_configure_args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
