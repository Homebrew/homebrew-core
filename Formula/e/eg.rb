class Eg < Formula
  desc "Expert Guide. Norton Guide Reader For GNU/Linux"
  homepage "https://github.com/davep/eg"
  url "https://github.com/davep/eg/archive/refs/tags/v1.02.tar.gz"
  sha256 "6b73fff51b5cf82e94cdd60f295a8f80e7bbb059891d4c75d5b1a6f0c5cc7003"
  license "GPL-2.0-or-later"
  head "https://github.com/davep/eg.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "8edac665cd76232a32ac5bb583b8002fa084c089a399a3d0c34e6843176fa47b"
    sha256                               arm64_sequoia:  "88dbfa7cf9217122bc925c3681ee19cefcdb758063696fa00577967301b34fbb"
    sha256                               arm64_sonoma:   "76e0f0b7dadc29420b7a83e10425eda231ba773ee90485838605b87d3934d964"
    sha256                               arm64_ventura:  "be6bd513bea9e8468a72127b84cb49d0ab0dc1d061c9fa42e799613ebb007357"
    sha256                               arm64_monterey: "e2612dfd6d458297a3c8b0b405ff7663150c28f5a7665e3b69158d61da5e80be"
    sha256                               arm64_big_sur:  "0f83d25f62f00b9a2e5170e8c33c1744476a193c54f174c6070d03ac80b18eaa"
    sha256                               sonoma:         "c82715ba3e91d77768529faebc425026682ba44bd272a10d41dd8a5245e6291e"
    sha256                               ventura:        "7934ccf9ab53a286897f8bf177884685ab0ea5ca2db8918428643b3bb8f54067"
    sha256                               monterey:       "038f9c8d57195f049357e2baa6b001f04bd6946e697f89a932530db05e3e52c8"
    sha256                               big_sur:        "cde213a2d4559ebbe2b3c964735e39bb4389eff052105d789f72cbabf9c4189d"
    sha256                               catalina:       "82c5cb9c305f5bcda5af0bac6143b6dec9798b7b301c17249e769e4018322225"
    sha256                               arm64_linux:    "99299828caf70e443733441b290c14d8a3c4fdb74de9f5d63be1678ca7ca88fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b56cf6712f27d8ec7ef757e04232e7d67921566701656a983a4eedcba812843f"
  end

  depends_on "s-lang"

  conflicts_with "eg-examples", because: "both install `eg` binaries"

  # Fix error: parameter 'iRefresh' was not declared, defaults to 'int';
  # ISO C99 and later do not support implicit int [-Wimplicit-int]
  patch :DATA

  def install
    inreplace "eglib.c", "/usr/share/", "#{etc}/"
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}", "NGDIR=#{etc}/norton-guides"
  end

  test do
    # It will return a non-zero exit code when called with any option
    # except a filename, but will return success if the file doesn't
    # exist, without popping into the UI - we're exploiting this here.
    ENV["TERM"] = "xterm"
    system bin/"eg", "not_here.ng"
  end
end

__END__
diff --git a/egscreen.c b/egscreen.c
index d3c7e66..31bbca3 100644
--- a/egscreen.c
+++ b/egscreen.c
@@ -211,7 +211,7 @@ void DisplayMessage( char *pszMsg, int iRefresh )
 /*
  */

-void ShowStdMsg( iRefresh )
+void ShowStdMsg( int iRefresh )
 {
     char *pszMsg = (char *) egmalloc( strlen( CurrentGuide( NULL ) ) +
                                       strlen( EG_VERSION ) + 7 );
