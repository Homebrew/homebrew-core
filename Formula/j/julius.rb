class Julius < Formula
  desc "Two-pass large vocabulary continuous speech recognition engine"
  homepage "https://github.com/julius-speech/julius"
  url "https://github.com/julius-speech/julius/archive/refs/tags/v4.6.tar.gz"
  sha256 "74447d7adb3bd119adae7915ba9422b7da553556f979ac4ee53a262d94d47b47"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b57b4070b691f3335a89ccbe7bc8160cf89ea13740554fe7bc139a44e27225fc"
    sha256 cellar: :any,                 arm64_sequoia: "90626fdb7e40c9ddfb802d560b463a0a986cdc78ce9f3299560981784c7234c2"
    sha256 cellar: :any,                 arm64_sonoma:  "5489d866714d1a191332dea80d20443dc097780a68ae3983883be5505f3406a1"
    sha256 cellar: :any,                 sonoma:        "bd47f837c69920f2fe4149028757fe97a97f5790d9f33ab33a023ffbabc6e332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68ee6c4454bf90a201afdeb9877d96bcd69db13177ad1b16bfe8f598e53d18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96922bc16267b3d31de8ff17570f1d163af94fd268168470ef560587b2059511"
  end

  depends_on "libsndfile"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "cmuclmtk", because: "both install `binlm2arpa` binaries"

  # A pull request to fix this has been submitted upstream:
  # https://github.com/julius-speech/julius/pull/184
  patch :DATA

  def install
    # Workaround for Xcode 15
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # https://github.com/julius-speech/julius/issues/153 fixes implicit declaration error
    inreplace "libsent/src/adin/adin_mic_darwin_coreaudio.c",
      "#include <stdio.h>", "#include <stdio.h>\n#include <sent/stddefs.h>"

    args = ["--disable-silent-rules", "--mandir=#{man}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
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
