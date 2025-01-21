class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.23.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.23.1.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.23.1.tar.gz"
  sha256 "52a578960fe308742367d75cd1dff8552c5797bd0beba7639e12bdcda28c0e49"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "9179f473099573a8c4a42f70e39f1a36376914d6b634e0975b5cb514dcecb4ee"
    sha256 arm64_sonoma:  "f3b350830a3da3a44f3981838651accad39c14a3bd0ceac8d4a3c94eb7b24c02"
    sha256 arm64_ventura: "2e98d7dae6dce086135060db70e767c5bfb0bcb8d190eea5f0a4c192315f2b0f"
    sha256 sonoma:        "89b1b668765938504ce64f991cf6b81fc96765f5dec84bbf64c007c3d811b8fe"
    sha256 ventura:       "fffb8da1a3258ca710829d0b9cf048d2a3434625e3fc202d845b0238ccc16d0f"
    sha256 x86_64_linux:  "a3f66e4195312f949e9b94b12de4d888945150b3e4dccfcb67403fde034ed073"
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
