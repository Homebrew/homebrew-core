class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "dev"

  stable do
    url "https://github.com/koka-lang/koka.git",
        tag:      "v3.1.2",
        revision: "3c4e721dd48d48b409a3740b42fc459bf6d7828e"

    # Backport fix to build with Cabal
    patch do
      url "https://github.com/koka-lang/koka/commit/86eb069440aa3e7da79b4f9b88867cfab4464354.patch?full_index=1"
      sha256 "97229ae11d735963a29ded3c10adfa6d12672b7d07277190d1af3a898ee6045d"
    end

    # Backport part of commit to build arm64 linux
    # https://github.com/koka-lang/koka/commit/cd1d644b73a9683554f97bcea2e0ca2469a7bb39
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d47eb2b41f0cd8cdb0d07acbbd4382b6ddb89cd4497af5b51d556bf8bab62b06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7506daa434b459eaa217e10e77c4307fc598661ee4d9545a4c48916c0a0dda56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b55493dad80f6ba85a9f2352982e88f863eb4ea69052816b66675a3ff9da564"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e16c7b9fa5a1e94040b624e47f04e2149771f77c36cf713ee3e6967cf16e4c83"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e6fa5200d8ea7e94d81c7b13f29860d70b4101a17f7f7d78d6bf528288c1781"
    sha256 cellar: :any_skip_relocation, ventura:        "a0ac5fddcd21811e58fdcc7964d6f6268436bc5227c5610688e817747bc711b3"
    sha256 cellar: :any_skip_relocation, monterey:       "090a3e3eab5c76f9eda70e6518cb9014324602b4791f4b96ea398cec9e93c818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d8791bbc514bb4bee3c4177bcc16fc865de042a5a53627caabbe774c9daa43"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pcre2" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    inreplace "src/Compile/Options.hs" do |s|
      s.gsub! '["/usr/local/lib"', "[\"#{HOMEBREW_PREFIX}/lib\""
      s.gsub! '"-march=haswell"', "\"-march=#{ENV.effective_arch}\"" if Hardware::CPU.intel? && build.bottle?
    end

    system "cabal", "v2-update"
    system "cabal", "v2-build", *std_cabal_v2_args.reject { |s| s["install"] }
    system "cabal", "v2-run", "koka", "--",
           "-e", "util/bundle.kk", "--",
           "--prefix=#{prefix}", "--install", "--system-ghc"
  end

  test do
    (testpath/"hellobrew.kk").write('pub fun main() println("Hello Homebrew")')
    assert_match "Hello Homebrew", shell_output("#{bin}/koka -e hellobrew.kk")
    assert_match "420000", shell_output("#{bin}/koka -O2 -e samples/basic/rbtree")
  end
end

__END__
diff --git a/kklib/include/kklib/bits.h b/kklib/include/kklib/bits.h
index 670cf2eaf8fc779fd7792b09a5919480bfe2a3a6..d5ede971c858d18e7aca9336556d7b8562119fd8 100644
--- a/kklib/include/kklib/bits.h
+++ b/kklib/include/kklib/bits.h
@@ -933,7 +933,7 @@ static inline uint64_t kk_clmul64_wide(uint64_t x, uint64_t y, uint64_t* hi) {
   return _mm_extract_epi64(res, 0);
 }
 
-#elif KK_ARCH_ARM64 && defined(__ARM_NEON) // (defined(__ARM_FEATURE_SME) || defined(__ARM_FEATURE_SVE))
+#elif KK_ARCH_ARM64 && defined(__ARM_NEON) && defined(__ARM_FEATURE_AES)
 #define KK_BITS_HAS_FAST_CLMUL64  1
 #include <arm_neon.h>
 #include <arm_acle.h>
