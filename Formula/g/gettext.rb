class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftpmirror.gnu.org/gnu/gettext/gettext-1.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-1.0.tar.gz"
  sha256 "85d99b79c981a404874c02e0342176cf75c7698e2b51fe41031cf6526d974f1a"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # libintl, libasprintf
  ]
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "2b713227e438f51d025d76df24cfa45a2b813b61718df7bb91a6cedb1091037b"
    sha256 arm64_sequoia: "dde3cd0db0d7549fadf762b901f8c548dae99e3c592a6e6d41f60e1436253e5e"
    sha256 arm64_sonoma:  "d11a97db1d735fb9860a9637e72b2765ef93536851d36c8f0b5cbbc22b539c5a"
    sha256 sonoma:        "e0072004be0db53c5f501d6ab2b78b9219067243f8989c40604720751dd6bdc4"
    sha256 arm64_linux:   "a436430dfcd915d3c9cd7888f6b4f82f7d02d1d9556f48bef218704df482879e"
    sha256 x86_64_linux:  "2dcf2f53d79cf6beb5c0df6f880c2cb7d21890be81533b3f74fc628d7f435cac"
  end

  depends_on "json-c" # for spit
  depends_on "libunistring"

  uses_from_macos "curl" # for spit
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "acl"
  end

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
