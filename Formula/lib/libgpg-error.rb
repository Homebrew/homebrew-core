class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.47.tar.bz2"
  sha256 "9e3c670966b96ecc746c28c2c419541e3bcb787d1a73930f5e5f5e1bcbbb9bdb"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cc9affb619675e392885d29c117a08f4f761176b23507156474620566810dd6c"
    sha256 arm64_ventura:  "89880157c066b02269207fb97fefc861f396c5787cad47089ef34c4a459ed282"
    sha256 arm64_monterey: "aeffa4d66556e265070446531d84cbe6a953b66ea53c34f6d89637db22635790"
    sha256 arm64_big_sur:  "1899eb9ba164578b36e85e97753ab4c09cbef831d0fa8f14e568530bc7a202e6"
    sha256 sonoma:         "bd833dc2e4864adf415010b6b57894e46931beff8bb5c280fa8fb23fa0311b9f"
    sha256 ventura:        "478d7c81b9bec50008638f93444ce1421b6ebbff07c23118587415ecfdabd79d"
    sha256 monterey:       "be6a020de8279043f0fd123f32bc2681da17db2edac2bba50ca6c5565842877e"
    sha256 big_sur:        "1bac110b0742324c549c26a76bc5b0f7702fd26dd3f72de773d356911184f7e9"
    sha256 x86_64_linux:   "c108c343e2fefc5fd01043e153aacd26a32396984eb6ed4b68702116efba5994"
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
