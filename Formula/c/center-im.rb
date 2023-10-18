class CenterIm < Formula
  desc "Text-mode multi-protocol instant messaging client"
  homepage "https://github.com/petrpavlu/centerim5"
  url "https://web.archive.org/web/20191105151123/https://www.centerim.org/download/releases/centerim-4.22.10.tar.gz"
  sha256 "93ce15eb9c834a4939b5aa0846d5c6023ec2953214daf8dc26c85ceaa4413f6e"
  license "GPL-2.0-or-later"
  revision 3

  # Modify this to use `url :stable` if/when the formula is updated to use an
  # archive from GitHub in the future.
  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d75f8b87c2bcd20519e83e938faccbc543fd1501b7c606d6ebb629a725ed9d63"
    sha256 arm64_ventura:  "06ea3b5f68d56428232fe118e9acd8991bc874339e4a871cc353090f8fd35279"
    sha256 arm64_monterey: "1a7055bb3ef5921a9a7879b1d5a6b1c1e208e10e74775118aa266e60fdc1b0b4"
    sha256 arm64_big_sur:  "da6277844c78cbc85d849be46094d4a67e3ab57cc6bf41d2cb5332a36db0ca7c"
    sha256 sonoma:         "6e36cf572c5c13d94fbbc516f9ae591c03103fabfbbf4c3cb2587cfbd6021909"
    sha256 ventura:        "eaac6faf7415659261e938587b564ee5190fe7df96ef1a7b9cd7e946a21a5c63"
    sha256 monterey:       "5647b6358b2c0c1b95fef613b5dd9818a584b2e127bbd85ee1dd329b698c4ebc"
    sha256 big_sur:        "d8b97d13db945bc0a2fe883bfa8394c70496f1cdd4bc8624c3fdf43dab824ccd"
    sha256 x86_64_linux:   "da7275cf3357b6ba3b363fc938f80e4639ebf5e0732b0f5705a1c467093d5567"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@3"

  uses_from_macos "curl"

  # Fix build with clang; 4.22.10 is an outdated release and 5.0 is a rewrite,
  # so this is not reported upstream
  patch :DATA

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/677cb38/center-im/patch-libjabber_jconn.c.diff"
    sha256 "ed8d10075c23c7dec2a782214cb53be05b11c04e617350f6f559f3c3bf803cfe"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Uses `auto` as a variable name.
    ENV.append "CXXFLAGS", "-std=gnu++03"

    # Work around for C++ version header picking up VERSION file on
    # case-insensitive systems. Can be removed on next update.
    (buildpath/"intl/VERSION").unlink if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-msn",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"

    # /bin/gawk does not exist on macOS
    inreplace bin/"cimformathistory", "/bin/gawk", "/usr/bin/awk"
  end

  test do
    assert_match "trillian", shell_output("#{bin}/cimconv")
  end
end

__END__
diff --git a/libicq2000/libicq2000/sigslot.h b/libicq2000/libicq2000/sigslot.h
index b7509c0..024774f 100644
--- a/libicq2000/libicq2000/sigslot.h
+++ b/libicq2000/libicq2000/sigslot.h
@@ -82,6 +82,7 @@
 #ifndef SIGSLOT_H__
 #define SIGSLOT_H__

+#include <cstdlib>
 #include <set>
 #include <list>
