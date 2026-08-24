class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.34.tar.xz"
  sha256 "84e8fe2a5a80a1ee7802013b3fbdb846a3f27a4163cf37a1c6d7c7f888873ead"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "141d0097dc90c0f2e921a4e771311f70a6e84af1055ab31358184e423c9513d1"
    sha256 cellar: :any, arm64_sequoia: "4a3b96bb12048cc93be05b45cde23dd1eb6bd1803cd4b0444968e0b981da57ed"
    sha256 cellar: :any, arm64_sonoma:  "a19ea4f2143fb6b1d0d65133e20bac5003544f08e92722120cfefa982a716dd0"
    sha256 cellar: :any, sonoma:        "73d756d1a1c5632e284e2db41f4aa72981d7d91a6d4e0a9b5b81723b0987579c"
    sha256               arm64_linux:   "96b5205fe0788e563c6dda1721424f2016e9c9a5f49411ec15693610c9fac36b"
    sha256               x86_64_linux:  "3aace6b37e534359cbf95cae9c6ba07a4884a06e65d50821017bd59161d91d09"
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
