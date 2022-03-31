class CenterIm < Formula
  desc "Text-mode multi-protocol instant messaging client"
  homepage "https://github.com/petrpavlu/centerim5"
  url "https://web.archive.org/web/20191105151123/https://www.centerim.org/download/releases/centerim-4.22.10.tar.gz"
  sha256 "93ce15eb9c834a4939b5aa0846d5c6023ec2953214daf8dc26c85ceaa4413f6e"
  revision 2

  # Modify this to use `url :stable` if/when the formula is updated to use an
  # archive from GitHub in the future.
  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "d91b8376deaa1aaaca8720dd9a45dbbd9dd2ea22035b308c5e798eb5cca62c8e"
    sha256 arm64_big_sur:  "182513b7096a23e8888d0d76858ad1c1d2ef92648f8f3d4140e291c41224ccbb"
    sha256 monterey:       "1a230141b53d9e46c63f7619e353ab00e8eeb7c42d106a0af646361d2fb1b246"
    sha256 big_sur:        "2b44902a2be528a4d9cae18e3b402691dc54a4c2241e72827a74bafe422d85cf"
    sha256 catalina:       "11a339b812d7fa164fce8e873e837d1ab07256e73ce0c4e483eeb60327ef6fa6"
    sha256 mojave:         "42a8b8f09b9530139c5d9eaf7c83a435962c61631eea00a13bf70a670044c7a2"
    sha256 high_sierra:    "9b40fc34ba5177765f01bdd821bec40377f44828421509491d90fb7a329ba400"
    sha256 sierra:         "7e9f2db21d3ceec8ad7d3a59e5bf600d5d145aa0a88f676d803c1feea307f687"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  # Fix build with clang; 4.22.10 is an outdated release and 5.0 is a rewrite,
  # so this is not reported upstream
  patch :DATA

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/677cb38/center-im/patch-libjabber_jconn.c.diff"
    sha256 "ed8d10075c23c7dec2a782214cb53be05b11c04e617350f6f559f3c3bf803cfe"
  end

  def install
    # Work around for C++ version header picking up VERSION file on
    # case-insensitive systems. Can be removed on next update.
    (buildpath/"intl/VERSION").unlink if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-msn",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
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
