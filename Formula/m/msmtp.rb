class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.28.tar.xz"
  sha256 "3a57f155f54e4860f7dd42138d9bea1af615b99dfab5ab4cd728fc8c09a647a4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c4c70693d1e16a0c6b8a55bf52a548760b3bc16df35bf0c70312ef2d57ffe187"
    sha256 arm64_sonoma:  "9194d0b211b262ff0022ff7e54e9c6ae3b91fbac8117e9efc4d20bafbf6a2bf1"
    sha256 arm64_ventura: "b529bbf1481c29d5d14fe62a45ab2860c29c173071add866bfe30627ff4b5da1"
    sha256 sonoma:        "d44aa70e8a8bebc73d42ed949d93269434aca16cd400826bba636d4a7e5d8d6e"
    sha256 ventura:       "0df3276cf5404eec6e3d88c2b052e0d16d957033eb55aff75e2e4d83f518cb5e"
    sha256 arm64_linux:   "c88f3518fbb8f4a3ff15a0806a64d5526af4a53bb379b276b72c691f6c6039a2"
    sha256 x86_64_linux:  "0ee69d963d12c0ec32977dcd57b555755024e480a433abb0cb40b0ecdb8425f2"
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
