class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.24.tar.gz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.24.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.24.tar.gz"
  sha256 "c918503d593d70daf4844d175a13d816afacb667c06fba1ec9dcd5002c1518b7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "be3555b4d0ed00fd50720e3f467cf9ca91fe0645ba29ba206f6bff2763b97e79"
    sha256 arm64_sonoma:  "123ddd7c859ada9372d2c79b4eb49b63dd900dc8f6f22d4d9420816ba078986d"
    sha256 arm64_ventura: "bbf800d209cdc2747742f435138a511e9448a1df8a16d3089d64df8e5c5398c2"
    sha256 sonoma:        "f4d648eb039e20e1cd0ac5f0fc33b4a5375e63c1e40b90c52ef19d1783556a92"
    sha256 ventura:       "5ffe9f8660b5d49e443d3e35b35b883e7be04b26de40b084b9915bf73fe425b0"
    sha256 arm64_linux:   "2878dd09f3efda346b40ac8c316fe8dfdd021f2f6a4b9d0b7193b703e258d873"
    sha256 x86_64_linux:  "044d6ca160c88e05c03e32d2c1c96643770d49d7d7616e350ad771a69e19671a"
  end

  depends_on "libunistring"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "acl"
  end

  def install
    # macOS iconv implementation is slightly broken since Sonoma.
    # This is also why we skip `make check`.
    # upstream bug report, https://savannah.gnu.org/bugs/index.php?66541
    ENV["am_cv_func_iconv_works"] = "yes" if OS.mac? && MacOS.version == :sequoia

    args = [
      "--with-libunistring-prefix=#{Formula["libunistring"].opt_prefix}",
      "--disable-silent-rules",
      "--with-included-glib",
      "--with-included-libcroco",
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

    system "./configure", *std_configure_args, *args
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end

  test do
    system bin/"gettext", "test"
  end
end
