class KyotoCabinet < Formula
  desc "Library of routines for managing a database"
  homepage "https://fallabs.com/kyotocabinet/"
  url "https://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.76.tar.gz"
  sha256 "812a2d3f29c351db4c6f1ff29d94d7135f9e601d7cc1872ec1d7eed381d0d23c"

  bottle do
    sha256 "0430d49ce4fd72454dd8e5d3a326f8172ff85e449d2766ca51f79e9045e8e2c0" => :mojave
    sha256 "2ba12ca100464a78f42b5b9d3540d99e26458d8bcac0bb9a530858b5bc49bc0a" => :high_sierra
    sha256 "24d4adf0747bebe9c3d90c509290bb630531f5184793d1866cd8ea7a39a1adce" => :sierra
    sha256 "c4b2e78762b188a19b3c6c2aec1733c59b03fd69d23aa2ae41ba8e756704c795" => :el_capitan
    sha256 "149125dc24b899ac4d6dd48a11aebb2ac092252b8e9cccac6472d3713062f914" => :yosemite
    sha256 "bfed1b4b4aa5e742c89f9aa0ba83375ad4ff1d5daaf0e060260d16df4024582d" => :mavericks
  end

  fails_with :clang do
    build 421
    cause <<~EOS
      Kyoto-cabinet relies on GCC atomic intrinsics, but Clang does not
      implement them for non-integer types.
    EOS
  end

  patch :DATA if MacOS.version >= :mavericks

  def install
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
