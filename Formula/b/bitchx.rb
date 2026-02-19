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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "a24e61a92b29742aed083f0630542dafa1b11daabbfbfe02ec73a1ba904789ff"
    sha256 arm64_sequoia:  "bb2902a6bb21cd1b2d5765652a7ef8c5b72a9ec645bab961d3d560320a96adb2"
    sha256 arm64_sonoma:   "774434de284a29888d4c9ed76671faf2903837d76a53acdfe25a8a358843c3ff"
    sha256 arm64_ventura:  "13c3a23d3e7316d509646ddbd5ee5442c096856124a4f2cc9123afee2ab66bfd"
    sha256 arm64_monterey: "2176f208cf2ef65ebe0fc9ea27d2581e21450a01f2b399aba4d0620085245bc2"
    sha256 arm64_big_sur:  "e92a812a3fdb12ef256f677a923b1343bd9a478beb41c988ea36845e6e154d75"
    sha256 sonoma:         "9a2c155cc9c8089674d95958a529145840263b0a9268707f30f2950e08ec3bad"
    sha256 ventura:        "c793d5d32ff5b4bb73d9c33f12b047459245ecc9f80883c66fac3ae9a30e2f6e"
    sha256 monterey:       "60c248c5f1b0a85a655ec9462b28982c4c0a089babdac242aedf9e0313a36f8e"
    sha256 big_sur:        "fb716a19bd25719a59a53270eb4dd4087d11946f44fe2a7adde6aeee183917fd"
    sha256 catalina:       "ea43f6d0776072e4a73f77621b676920c7a85c0b35446e29d61612c2e68d1ce8"
    sha256 arm64_linux:    "4f34b4f508810bd50085303aa389932e4834bbf95db9ccecc01fc4b63a3e9039"
    sha256 x86_64_linux:   "99bec310978096fc74fb480bd558108eb6f9a476ce0dc6721c84a5023f6913c4"
  end

  depends_on "openssl@3"

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
