class KyotoCabinet < Formula
  desc "Library of routines for managing a database"
  homepage "https://dbmx.net/kyotocabinet/"
  url "https://dbmx.net/kyotocabinet/pkg/kyotocabinet-1.2.79.tar.gz"
  sha256 "67fb1da4ae2a86f15bb9305f26caa1a7c0c27d525464c71fd732660a95ae3e1d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://dbmx.net/kyotocabinet/pkg/"
    regex(/href=.*?kyotocabinet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "3f3bda6747d743ddd1300f8df99662734395466240c46ac835648c3e38fc5526"
    sha256 arm64_monterey: "56224898ed5bf4ceecccd79901b90191180b89d4bf48e7cc218dbeff28fecc9d"
    sha256 arm64_big_sur:  "fa9322ae66dc8295d2f60365999a371c6602bcfd98f050e0897992e745c53d93"
    sha256 ventura:        "cbf9dd9b70f76c786714ab690d6a381fd9cd73d187b1bcae3f805331768cb43f"
    sha256 monterey:       "5aee992a2c97e53568a06313204e83e795debab5260ca564fa846e982db8ed10"
    sha256 big_sur:        "8a7873835b5790ece37b54d398daf834e7aa75570202cd7a174ba7e5ebecf6a3"
    sha256 catalina:       "c78b84f7dc1e82f12a8bdbeb934abeb9858968fa8c53dee9a405b1e55b49155d"
    sha256 mojave:         "214ade984ae17b36058ceca13c37fb5612da6daa0c7cbd919e635c1c714a4a1b"
    sha256 x86_64_linux:   "4e6693149609f558bf30685031113391e230fab20a738ab0ad98c08ef8bc1545"
  end

  uses_from_macos "zlib"

  patch :DATA

  def install
    ENV.cxx11
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make", "install"
  end
end


__END__
--- a/kccommon.h  2013-11-08 09:27:37.000000000 -0500
+++ b/kccommon.h  2013-11-08 09:27:47.000000000 -0500
@@ -82,7 +82,7 @@
 using ::snprintf;
 }

-#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER)
+#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER) || defined(_LIBCPP_VERSION)

 #include <unordered_map>
 #include <unordered_set>
