class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.15.tar.gz"
  sha256 "91c221eb989e576ca78df05f69bf900dd029da222efb631cb86c6895a2b5a0dd"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_ventura:  "e75d304e1712b84bdb45b1ab0ccc32ba9bee61db3b9fca52705d101bee7ae0fc"
    sha256 arm64_monterey: "6dcdd66942b8fb1ba092d7b720c2fc0f4b837963ff1e832fc40d0f2f0c774164"
    sha256 arm64_big_sur:  "e1f4e8aac69d4653d5aeb7422a0aaef2c34510742148ac3878a1af72905e758c"
    sha256 ventura:        "fb8bdc5d1bb41280be4612e99b1ccd608f1c8ee226d0fccaa14ca5a9fa03f0d9"
    sha256 monterey:       "144c0d2fa0fd8939c4f0f8f7c50efc70ced0aba365282f2110683c4915bdc89e"
    sha256 big_sur:        "7cdd48ce8344e2dc5a1ae1b1a8047759b913bc82940445f39bf7fd8dc50e903e"
    sha256 x86_64_linux:   "4e37c2551fc2c40e937c2c7b67a9cb9b86a542d3de22e4d07b0ef23673340e63"
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # This is hardcoded to be owned by `root`, but we have no privileges on installation.
    inreplace buildpath.glob("dotlock/Makefile.*") do |s|
      s.gsub! "chown root:mail", "true"
      s.gsub! "chmod 2755", "chmod 755"
    end

    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-fribidi",
                          "--without-gdbm",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
