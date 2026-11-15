class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftpmirror.gnu.org/gettext/gettext-1.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-1.0.tar.gz"
  sha256 "85d99b79c981a404874c02e0342176cf75c7698e2b51fe41031cf6526d974f1a"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # libintl, libasprintf
  ]
  compatibility_version 1

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "4db034aa2ae4b1f18d86906707ece14c895198090ad028d2fb1ae4fbeb3ca6fd"
    sha256 arm64_tahoe:       "3af5392939e50a6ef73e42799fc3ead6ef72fe0040c0a45183d04a4008306d6a"
    sha256 arm64_sequoia:     "98a116d35792ccd730360ffc8c0d8fc5799b2282b96bb7696192c573f064a331"
    sha256 arm64_linux:       "3cad13274e2b89d4b625623c0e6553b341dc04f2f24465892c511332dc80c2d2"
    sha256 x86_64_linux:      "2d8896fdb7fe81fc987cefd609ddcd3696f99b71b7b6b60508a2c53f0e99eb5a"
  end

  depends_on "json-c" # for spit
  depends_on "libunistring"

  uses_from_macos "curl" # for spit
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "acl"
  end

  deny_network_access!

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # macOS iconv implementation is slightly broken since Sonoma.
    # upstream bug report, https://savannah.gnu.org/bugs/index.php?66541
    ENV["am_cv_func_iconv_works"] = "yes" if OS.mac? && MacOS.version >= :sequoia

    args = [
      "--with-libunistring-prefix=#{formula_opt_prefix("libunistring")}",
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
      "--with-libxml2-prefix=#{formula_opt_prefix("libxml2")}"
    end

    system "./configure", *std_configure_args, *args
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end

  test do
    system bin/"gettext", "test"
    assert_match "spit: missing --model option\n", shell_output("#{bin}/spit 2>&1", 1)
  end
end
