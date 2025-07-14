class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.25.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.25.1.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.25.1.tar.gz"
  sha256 "746f955d42d71eb69ce763869cb92682f09a4066528d018b6ca7a3f48089a085"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "740b5076c4bcbf2caa40018a9ae18750a23495b9aad8ca82314004be3dad9faf"
    sha256 arm64_sonoma:  "80a935b81e6d1e562c6b7570d05361e62e800402b0d982438d9aa3d492575543"
    sha256 arm64_ventura: "6281ec93a5c85681dcee3a161711af16d76106d6e1b136d08fa077489a080e65"
    sha256 sonoma:        "038b86f44028bb39ad7132d042765a40a5f1ed56797346ffee813d24228764c4"
    sha256 ventura:       "6ed89bab58e5e53b3920c177e1011b3e5635fac2998155447f31db8e4a2e8cee"
    sha256 arm64_linux:   "a9cc4a0d143367536c3ccefdfda303dc5aaabec05268a5b4fa3c9fccb517ae11"
    sha256 x86_64_linux:  "dfc27f49bf89bd75dc0d9875031ad3f9517ef9a4e522ccbce3f6191b62d4a604"
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
