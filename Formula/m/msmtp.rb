class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.30.tar.xz"
  sha256 "f826a3c500c4dfeed814685097cead9b2b3dca5a2ec3897967cb9032570fa9ab"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "38068c142cd311018f9df7b5f830d9d8f276dfbd5b92e53421b9a0d237c89714"
    sha256 cellar: :any, arm64_sonoma:  "49fa246ddc32ff8c42d489a4319e9899b717ed9beb8ab1a0241fa1eb0a5d4237"
    sha256 cellar: :any, arm64_ventura: "fa42011c0c5dfebdfb290fc14b4824272d4cf7953a0c7b7a08bb3d137e1404e4"
    sha256 cellar: :any, sonoma:        "792a7e947d956b79bc035f203a763195ab00a0f9cc4fe237c8dc584ae606e8ea"
    sha256 cellar: :any, ventura:       "feabf234f1333ae0e89243d288ef0a58908324290d52413956da4d5b96fb4949"
    sha256               arm64_linux:   "709e18cbad71d93a8c0e658e25ebbc042ab6f7d5a21a7981f60b52d154ddaaeb"
    sha256               x86_64_linux:  "e3e8a2abfee28a3f75af8d4d7bf46dc6d30f023b63647824ef9873cbab7edd2a"
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
