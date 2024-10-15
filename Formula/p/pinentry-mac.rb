class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry"
  url "https://github.com/GPGTools/pinentry/archive/refs/tags/v1.1.1.1.tar.gz"
  sha256 "1a414f2e172cf8c18a121e60813413f27aedde891c5955151fbf8d50c46a9098"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]
  revision 1
  head "https://github.com/GPGTools/pinentry.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "1759d4b87b044210921e272a7b17088619a0926cc0cf2e6575ce41a67e23dd76"
    sha256 cellar: :any, arm64_sonoma:   "d9b12bddf25fdd63200405e9d47e97b0f26f1a7072008f4a162a4904057ea793"
    sha256 cellar: :any, arm64_ventura:  "16372bcfc0e902ab575e8e1cd8413c6e2079cec95b0b932713351f1e412fc23c"
    sha256 cellar: :any, arm64_monterey: "b8cc948168aee564dee88bc7cd7d6ab027890a9f4535d2d5e097bbd7a4de9c33"
    sha256 cellar: :any, sonoma:         "7274251e5bccbbb1bd94323d42a345e35eb5a963ee22f88d234d5624a1ec5dab"
    sha256 cellar: :any, ventura:        "75d4f6ca57c0ee9b2f5bcb1160476dbe120d9208b234eb3e7e9cc39da11ef2d0"
    sha256 cellar: :any, monterey:       "99e48f5cb775d70647132279317d6f3d1999f97df4db76e8631ddc76c88b79fe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on xcode: :build # for ibtool
  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on :macos

  # Apply commit from `pinentry` to allow newer `libassuan`
  # Ref: https://github.com/gpg/pinentry/commit/a39ba412ab24721d4edb6476156371f8bf1d3ff9
  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--disable-doc",
                          "--disable-ncurses",
                          "--disable-silent-rules",
                          "--enable-maintainer-mode",
                          *std_configure_args
    system "make"
    prefix.install "macosx/pinentry-mac.app"
    bin.write_exec_script prefix/"pinentry-mac.app/Contents/MacOS/pinentry-mac"
  end

  def caveats
    <<~EOS
      You can now set this as your pinentry program like

      ~/.gnupg/gpg-agent.conf
          pinentry-program #{HOMEBREW_PREFIX}/bin/pinentry-mac
    EOS
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/pinentry-mac --version")
  end
end

__END__
diff --git a/m4/libassuan.m4 b/m4/libassuan.m4
index 79391bb..a2eb5d9 100644
--- a/m4/libassuan.m4
+++ b/m4/libassuan.m4
@@ -89,6 +89,7 @@ AC_DEFUN([_AM_PATH_LIBASSUAN_COMMON],

   if test $ok = yes; then
     AC_MSG_RESULT([yes ($libassuan_config_version)])
+    AC_DEFINE(LIBASSUAN_API_REQUESTED, $req_libassuan_api, Requested API version for libassuan)
   else
     AC_MSG_RESULT(no)
   fi
@@ -104,6 +105,8 @@ AC_DEFUN([_AM_PATH_LIBASSUAN_COMMON],
         AC_MSG_CHECKING([LIBASSUAN API version])
         if test "$req_libassuan_api" -eq "$tmp" ; then
           AC_MSG_RESULT(okay)
+        elif test "$req_libassuan_api" -eq 2 -a "$tmp" -eq 3; then
+          AC_MSG_RESULT(okay)
         else
           ok=no
           AC_MSG_RESULT([does not match.  want=$req_libassuan_api got=$tmp.])
