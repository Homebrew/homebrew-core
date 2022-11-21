class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.15.tar.gz"
  sha256 "91c221eb989e576ca78df05f69bf900dd029da222efb631cb86c6895a2b5a0dd"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "fe6df858b6fffac5a923a492688f5ce932cef0db1ab5e72cf4d14bbe92942c68"
    sha256 arm64_monterey: "426b911485f56b5573c4359ee718595f08111a2a4b2a94f817e6f6db3379da62"
    sha256 arm64_big_sur:  "0f7c09f21a3b72ac671636ff5daf57634c884f2e7c08f7892b6a817e50a76502"
    sha256 ventura:        "3ebc6af0182c4a918cd596488a3274a83d5df78a70790a5210d192c1b1280b62"
    sha256 monterey:       "272136d7ac286707a7f5b8dd930b33418be1aae687cc5cc1ce33c45aee5edc67"
    sha256 big_sur:        "87abad1ddb3cb7e5eaf11d10eddc576d468377aeafa36bf27caa727e76f9b48e"
    sha256 catalina:       "b05e18d18e02f03972d185df7cde5b73fc15f4e269729a4ce32a58d728dfac41"
    sha256 x86_64_linux:   "62de27f74d3664213351a495ad18e96d2682a506578e4efdd7b2fc82b5a80698"
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
