class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.56.tar.bz2"
  sha256 "82c3d2deb4ad96ad3925d6f9f124fe7205716055ab50e291116ef27975d169c0"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c5a04a6d7e3628a9ce018d9acdf269e1a6b5f0eb8a50803ce047da9a73fabf52"
    sha256 arm64_sequoia: "9dd171019b3b4161374ff8886591ff79270d475f2f000f5b9d6bf9535f75352a"
    sha256 arm64_sonoma:  "7d5fb8a99b6c9c1fb487da8bb4ecb155ee89e537bc26bc5e7cac3fbbc3420470"
    sha256 sonoma:        "79fded0b2f1818067dd828aa1c3c9d95d8a22ea31bc1541bc7d2bc6d5cd3a90d"
    sha256 arm64_linux:   "11d136c0bcd5402f317b4caaf0c904e1da431c0c44e480d2966749453e55d6ba"
    sha256 x86_64_linux:  "fa8d70d9720645a83a9f0aa84d1fe5dcb631429f724608004c4d18a2d7a19845"
  end

  on_macos do
    depends_on "gettext"
  end

  def install
    # NOTE: gpg-error-config is deprecated upstream, so we should remove this at some point.
    # https://dev.gnupg.org/T5683
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-install-gpg-error-config",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace [bin/"gpg-error-config", lib/"pkgconfig/gpg-error.pc"], prefix, opt_prefix
  end

  test do
    system bin/"gpgrt-config", "--libs"
  end
end
