class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.22.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.22.2.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.22.2.tar.gz"
  sha256 "a99662bafc1cc683ec7740844b465c7f30ccb044967f157f74697df9a9306b0e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "a73c646625fe97ee22d498644e7c7f4ff1697f0ee817acbb7205921675f1ccd2"
    sha256 arm64_ventura:  "7dc306a073a88a53e457afd750139cf73785c299dd112cbeae051e114249ba38"
    sha256 arm64_monterey: "7fe0c884f86c98ff759c6a97e1ab1627de063b18c8b7b680a3f2d9c75832283f"
    sha256 arm64_big_sur:  "7c4aaea1463292d29ba3fe0d081abbae1e965e470cb4e4acd69432f87932e544"
    sha256 sonoma:         "befd20cde015ca6994d0e35574433a740bf996f96c951095b88b9721b6546be3"
    sha256 ventura:        "b6bf2952286f24785b3e1bb6604f5d5c5e922e02d3e62aa3c92793a960421340"
    sha256 monterey:       "57ddf5a74671707ef8d69a46abf4848ffe2f98313e74cd08afaca1597cdfbf55"
    sha256 big_sur:        "cfa5dcfd468ed1ae9598870d76c6e132a9599cef62bc35852f18da9e7e420675"
    sha256 x86_64_linux:   "0b080f8b9f94831aa4a33d771bc933030e93df47696b5d403e854b06357bec09"
  end

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    args = [
      "--disable-silent-rules",
      "--with-included-glib",
      "--with-included-libcroco",
      "--with-included-libunistring",
      "--with-included-libxml",
      "--with-emacs",
      "--with-lispdir=#{elisp}",
      "--disable-java",
      "--disable-csharp",
      # Don't use VCS systems to create these archives
      "--without-git",
      "--without-cvs",
      "--without-xz",
    ]
    args << if OS.mac?
      # Ship libintl.h. Disabled on linux as libintl.h is provided by glibc
      # https://gcc-help.gcc.gnu.narkive.com/CYebbZqg/cc1-undefined-reference-to-libintl-textdomain
      # There should never be a need to install gettext's libintl.h on
      # GNU/Linux systems using glibc. If you have it installed you've borked
      # your system somehow.
      "--with-included-gettext"
    else
      "--with-libxml2-prefix=#{Formula["libxml2"].opt_prefix}"
    end

    # Sonoma iconv() has a regression w.r.t. transliteration, which happens to
    # break gettext's configure check. Force it.
    # Reported to Apple as FB13163914
    args << "am_cv_func_iconv_works=y" if OS.mac? && MacOS.version == :sonoma

    system "./configure", *std_configure_args, *args
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end

  test do
    system bin/"gettext", "test"
  end
end
