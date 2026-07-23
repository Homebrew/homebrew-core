class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.33.tar.xz"
  sha256 "41c163ce2c4c8c3c326cda8d0abd9391a7323788f0a893f49bfbe7aff3d4f276"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "18baf7488e695a070706d4ca609b78ae48f617d81b80099804e7c619058448cc"
    sha256 cellar: :any, arm64_sequoia: "50eaf47e602bcfb9c4f83bbd40f18b7e6e47d9dbb2d0bc1116b9bfec7ceb537f"
    sha256 cellar: :any, arm64_sonoma:  "164ba7a0937721c7cfe405221c37e52c5bd1350523f8d9c11b7a141395478733"
    sha256 cellar: :any, sonoma:        "90590c175652dfeda45745a61c5a5b141086ebd4841fa6ca6ea3e1ad59db7b79"
    sha256               arm64_linux:   "4e4693701bc0c615fbae27512638efa3cef964d6eddec1447726d3dec086fcb3"
    sha256               x86_64_linux:  "7c7d0eb42bd81d44aa932584b7aac518076406098c64f03459bc9a391fd8ff28"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libidn2"

  on_macos do
    depends_on "gettext"
  end

  def install
    # gnulib's base64.h uses `bool` without including
    # <stdbool.h>, assuming C23. Force the include for pre-C23 compilers.
    ENV.append_to_cflags "-include stdbool.h"

    system "./configure", "--disable-silent-rules", "--with-macosx-keyring", *std_configure_args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
