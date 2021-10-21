class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.42.tar.bz2"
  sha256 "fc07e70f6c615f8c4f590a8e37a9b8dd2e2ca1e9408f8e60459c67452b925e23"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "52651d0013588855c79008c9f643490ccfbe6bb19f424f5e2bf7b6d924e382cd"
    sha256 arm64_big_sur:  "70e6813ed4afc576346a5fb6aa2670f0004bcc67c63b19bc4d83c9d88451ba0a"
    sha256 monterey:       "620a34647a3c5bb70427b846792674187a39f58e18688cf29d88cf48bacd28bb"
    sha256 big_sur:        "6fa4b76fb160c8c75d4d1f932c3c920902a97474741397def5d4000201e85436"
    sha256 catalina:       "b9b74abe24d72b7ffecc89aba01d370d5f60d232af1c4bbeebe4a8fd3f54b907"
    sha256 mojave:         "1708cb4a9d2a4ac4e49bc37d9b7bbd259e1c5cfb1ffeb070bc956058e3081f47"
    sha256 x86_64_linux:   "f81788fbebc232e9d57e82ba29dc9e0387be0190f2e9e1fad802ef97b24b5358"
  end

  # libgpg-error's libtool.m4 doesn't properly support macOS >= 11.x (see
  # libtool.rb formula). This causes the library to be linked with a flat
  # namespace which might cause issues when dynamically loading the library with
  # dlopen under some modes, see:
  #
  #  https://lists.gnupg.org/pipermail/gcrypt-devel/2021-September/005176.html
  #
  # We patch `configure` directly so we don't need additional build dependencies
  # (e.g. autoconf, automake, libtool)
  #
  # This patch has been applied upstream so it can be removed in the next
  # release.
  #
  # https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgpg-error.git;a=commit;h=a3987e44970505a5540f9702c1e41292c22b69cf
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
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
