class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.25.tar.gz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.25.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.25.tar.gz"
  sha256 "aee02dab79d9138fdcc7226b67ec985121bce6007edebe30d0e39d42f69a340e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "8dba9424a9409d3ba085acccfd8c88c196e31e31944c32c1d811cfdd6aae8280"
    sha256 arm64_sonoma:  "19c917a48a53614a6f6a611c018cc2884466268638d0aabb4c2f596684b94e9f"
    sha256 arm64_ventura: "af2c9962b3d92649642157dc7630672b18825a462b0c9d4f7285df58b7c2efa8"
    sha256 sonoma:        "6da9896ebaea0fd919d220f661cf8b68397ac038d0c3139ab4132a285496cdf9"
    sha256 ventura:       "cd17c1763a6784e768d976615ecb13cfe3282b9677a954198385539eb2f99944"
    sha256 arm64_linux:   "cb8b6b07dc9e7f191cc8bcfe0a2ef7f4ef6c2a7e60914375dee6a1b61f7b2fb4"
    sha256 x86_64_linux:  "8e4b8222d6c3a550ac7601d6f092807b2c41c11d35dd4680cba11d54dee8c449"
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
