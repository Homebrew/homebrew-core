class Julius < Formula
  desc "Two-pass large vocabulary continuous speech recognition engine"
  homepage "https://github.com/julius-speech/julius"
  url "https://github.com/julius-speech/julius/archive/v4.6.tar.gz"
  sha256 "74447d7adb3bd119adae7915ba9422b7da553556f979ac4ee53a262d94d47b47"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "345963770e4eaa6cd0a4308d657f4b0a45b00d30e23d5e7aba9143dee08f418b"
    sha256 cellar: :any,                 arm64_monterey: "61e0a2f95974a4fdfaee2253963fe3ab20284c4325e0f34aa22bc4a9e40a09c0"
    sha256 cellar: :any,                 arm64_big_sur:  "dcbb2b7bfd4ba078ec6473c2193ca6fefd3f1cbe6375bd662401a5b607d99387"
    sha256 cellar: :any,                 ventura:        "c4229059cd82483a8bb92be7fdaadb2d1958e4be61001fa539f71fde025eada6"
    sha256 cellar: :any,                 monterey:       "73f943f1011686778fdae712733eb0987f97976c6f0ab26d9771c57eccf304c9"
    sha256 cellar: :any,                 big_sur:        "4b8251857584f844fe5469a0283a773428383053f8d80eaeff885b745578aa1d"
    sha256 cellar: :any,                 catalina:       "b06b9ca71df4cccff10e36a4a75a55f7d5bdb009f4dba9f940044da6ba0c258d"
    sha256 cellar: :any,                 mojave:         "041d7a3185850375ef67148a74ab9513e9a4eb6de05deeb3595f3941c41010d6"
    sha256 cellar: :any,                 high_sierra:    "d699dbf645c69f795421569e21c9d676e0db534a8d72fabfb721d5864e391549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576576ac4069a3fd9e89e71ac2cefe9f3d1e666b9aa92915f248f8bffcf19de5"
  end

  depends_on "libsndfile"

  uses_from_macos "zlib"

  # A pull request to fix this has been submitted upstream:
  # https://github.com/julius-speech/julius/pull/184
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/julius --help", 1)
  end
end

__END__
diff --git a/libsent/src/phmm/calc_dnn.c b/libsent/src/phmm/calc_dnn.c
index aed91ef..a8a9f35 100644
--- a/libsent/src/phmm/calc_dnn.c
+++ b/libsent/src/phmm/calc_dnn.c
@@ -45,7 +45,7 @@ static void cpu_id_check()
 
   use_simd = USE_SIMD_NONE;
 
-#if defined(__arm__) || TARGET_OS_IPHONE
+#if defined(__arm__) || TARGET_OS_IPHONE || defined(__aarch64__)
   /* on ARM NEON */
 
 #if defined(HAS_SIMD_NEONV2)
