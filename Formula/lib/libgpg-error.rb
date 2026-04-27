class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.60.tar.bz2"
  sha256 "11b2a738e212f3eab0fe8637bc341d3181ca964e97bb2654de91aab7dae4ce09"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cdd3c756b205ee65e53fdcc9dfd57097441f3600661ad12cc60b7dab01466cbf"
    sha256 arm64_sequoia: "9087711ee2f274188d56a46deb17e211a22d9e8c7733b04ba4b8b03cfe5413d3"
    sha256 arm64_sonoma:  "2a34d537e372600150eded1a2e777ad6ba5ae753d5225e12c00e5fab55814086"
    sha256 sonoma:        "6ef67ea1a4ac34f748ebc870a2aa01566c18d4d433540419719972ed4cbe587c"
    sha256 arm64_linux:   "cda9f81ec8b8b53a1b95a6cdcadd3ae9d9057838f355e80d026de84627f87c37"
    sha256 x86_64_linux:  "5b41692978f5b552804b4568a11422115051de30025207164e2d337571f1a6f3"
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
