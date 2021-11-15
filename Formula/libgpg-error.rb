class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.43.tar.bz2"
  sha256 "a9ab83ca7acc442a5bd846a75b920285ff79bdb4e3d34aa382be88ed2c3aebaf"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b4c6d3c58947872d8c6d669e578b65606768d3644283e1bcb74af3f646fef265"
    sha256 arm64_big_sur:  "74ee5137d12831d2264ff4fd919e2f0421ae82554874022a7d347f9353517a75"
    sha256 monterey:       "aa290c28ce14262ca8c325c04fc798df18a38db209227e53d2e7581a34c09e88"
    sha256 big_sur:        "14e9943f082e960a86acb6098f6f327a3bbdb3f24459a883fb4bc51eeaf1cd98"
    sha256 catalina:       "1ba97571b790787c33916b0a0592905c6426bc84fb6b199c0198bad84e873b91"
    sha256 x86_64_linux:   "d6ef6b7739695c8058ec65862519f108744359c6e981f8dd218cd5cfaf33a690"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpg-error-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
