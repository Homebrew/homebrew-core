class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.49.tar.bz2"
  sha256 "8b79d54639dbf4abc08b5406fb2f37e669a2dec091dd024fb87dd367131c63a9"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "7473b0f8035b06d01bd0770e830f194d9b96eb0b42071fde9fd8275a6c62439b"
    sha256 arm64_ventura:  "bfc628bab49e64ecf7680ae451d49785063dc366f1d171414d28a102c68c313e"
    sha256 arm64_monterey: "c250e817825c6b7e02cde2adac399397b805ea2cd7eadbcfe8271adc6dede6a0"
    sha256 sonoma:         "2a0b65d124ca8a17b753429d1440062c3661c7a8db0d4aeb2974eaa3282d3879"
    sha256 ventura:        "24b0a78e668d215395a3cef954988d842ff8d7991d9aa8bcd8ea26cc8115575a"
    sha256 monterey:       "1feff61a050b82d59cb3d72355cd246e2f938713944ffdd44fff2651b4e77352"
    sha256 x86_64_linux:   "225d361c850575dcf123790dfe952d005ceb67b57a33e23a1eccfb086aab81e2"
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
