class Bitchx < Formula
  desc "Text-based, scriptable IRC client"
  homepage "https://bitchx.sourceforge.net/"
  license "BSD-3-Clause"
  revision 1
  head "https://git.code.sf.net/p/bitchx/git.git", branch: "master"

  stable do
    url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
    sha256 "2d270500dd42b5e2b191980d584f6587ca8a0dbda26b35ce7fadb519f53c83e2"

    # Apply these upstream commits to fix Linux build:
    # https://sourceforge.net/p/bitchx/git/ci/1c6ff3088ad01a15bea50f78f1b2b468db7afae9/
    # https://sourceforge.net/p/bitchx/git/ci/4f63d4892995eec6707f194b462c9fc3184ee85d/
    # Remove with next release.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/bitchx/linux.patch"
      sha256 "99caa10f32bfe4727a836b8cc99ec81e3c059729e4bb90641be392f4e98255d9"
    end

    # Backport part of upstream commit to add static specifiers needed to fix Sonoma build
    # Ref: https://sourceforge.net/p/bitchx/git/ci/7e3c39a464635eb22484161513410ecbb666f840/
    patch :DATA
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "7e65b3f85145e10a3622f5b6d3302292f53a6cf4e895cc497595c70d3fb5f04e"
    sha256 arm64_sequoia: "f46880225ae77a603ea81fb7dda6762e4f25954b1b35753b51c0dd8707b5317b"
    sha256 arm64_sonoma:  "b472d9378d5349dfe5a705a3bdca6f5a7acbf5aeb418d2f2a04fd3719df746c9"
    sha256 sonoma:        "dda418692213cb2577d76916cd29cab33a721fd77b3e5017de637b133399b7de"
    sha256 arm64_linux:   "a45103a072852383c3e5afad9f786dadd82205b5e487dbd892b4af38fbfe48fe"
    sha256 x86_64_linux:  "7454146fddf939532a4832c5276107ae6a64448a40ce95a39c370813d899d228"
  end

  depends_on "openssl@4"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    plugins = %w[
      acro arcfour amp autocycle blowfish cavlink encrypt
      fserv hint identd nap pkga possum qbx qmail
    ]

    # Remove following in next release
    if build.stable?
      # AIM plugin was removed upstream:
      # https://sourceforge.net/p/bitchx/git/ci/35b1a65f03a2ca2dde31c9dbd77968587b6027d3/
      plugins << "aim"

      # Patch to fix OpenSSL detection with OpenSSL 1.1
      # A similar fix is already committed upstream:
      # https://sourceforge.net/p/bitchx/git/ci/184af728c73c379d1eee57a387b6012572794fa8/
      inreplace "configure", "SSLeay", "OpenSSL_version_num"

      # Work around for new Clang. HEAD build does not hit issues.
      if DevelopmentTools.clang_build_version >= 1500
        ENV.append_to_cflags "-Wno-implicit-function-declaration"
        ENV.append_to_cflags "-Wno-incompatible-function-pointer-types"
        ENV.append_to_cflags "-Wno-int-conversion"
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-ipv6",
                          "--with-plugins=#{plugins.join(",")}",
                          "--with-ssl"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"BitchX", "-v"
  end
end

__END__
diff --git a/source/expr2.c b/source/expr2.c
index f607707..657a2bc 100644
--- a/source/expr2.c
+++ b/source/expr2.c
@@ -1192,7 +1204,7 @@ int	lexerr (expr_info *c, char *format, ...)
  * case 'operand' is set to 1.  When an operand is lexed, then the next token
  * is expected to be a binary operator, so 'operand' is set to 0.
  */
-__inline int	check_implied_arg (expr_info *c)
+static __inline int	check_implied_arg (expr_info *c)
 {
 	if (c->operand == 2)
 	{
@@ -1205,7 +1217,7 @@ __inline int	check_implied_arg (expr_info *c)
 	return c->operand;
 }

-__inline TOKEN 	operator (expr_info *c, char *x, int y, TOKEN z)
+static __inline TOKEN 	operator (expr_info *c, char *x, int y, TOKEN z)
 {
 	check_implied_arg(c);
 	if (c->operand)
@@ -1216,7 +1228,7 @@ __inline TOKEN 	operator (expr_info *c, char *x, int y, TOKEN z)
 	return z;
 }

-__inline TOKEN 	unary (expr_info *c, char *x, int y, TOKEN z)
+static __inline TOKEN 	unary (expr_info *c, char *x, int y, TOKEN z)
 {
 	if (!c->operand)
 		return lexerr(c, "An operator (%s) was found where "
