class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.58.tar.bz2"
  sha256 "f943aea9a830a8bd938e5124b579efaece24a3225ff4c3d27611a80ce1260c27"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9ffe4c585c9f48a1afeb503d849b26d2a8595b8e2144febed9af1b4d35c31424"
    sha256 arm64_sequoia: "93e000a1b097f8ea2c814b2c201c44f1cf31ec6cc3498b6c79f5924f4c086fef"
    sha256 arm64_sonoma:  "413f3b28173f2f2da647226e5d0931be1f5628cf80271f7a73a8ea694a3b770c"
    sha256 sonoma:        "a9c5a3e98d959137a959c255a08fff83d406139f91c605cb24591a8d6aa46c73"
    sha256 arm64_linux:   "c54d011e043bb2b96d434b868c1b27da9ddc8af74fe3c75efd298b5eb0edf2cb"
    sha256 x86_64_linux:  "5548d77d1d4de09b0b94a163ccc7188c8faa787bbd145859e06bc6cf261c24c5"
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
