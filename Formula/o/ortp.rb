class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.104/ortp-5.3.104.tar.bz2"
    sha256 "d548e369c22350fd436f7d7755ff1112e57dfe7831d2c4b5fbdef08456785cc4"

    depends_on "mbedtls"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.104/bctoolbox-5.3.104.tar.bz2"
      sha256 "7ef49eaf25576f2c220a20bd3016ee73ee15630b7694e969d4d14f433a57ca1a"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94bfde5516745edf92a91e635a3136459fb8270d0983de2c94221cf901092ad5"
    sha256 cellar: :any,                 arm64_sonoma:  "eccc87d7d9578b3fcf7b28412fbf95df98638bfafc8f0265d135800f2d8c44dc"
    sha256 cellar: :any,                 arm64_ventura: "b1c1488b724a4870a4ad9bc86665567cbf79c900e287a07f127d50434c946d22"
    sha256 cellar: :any,                 sonoma:        "beecd9fe5251c80b2c0121af821a0061efb8b1c70ec0e915ca29fa108b574e0b"
    sha256 cellar: :any,                 ventura:       "530020ff72516e53b969bc160f7a2c1a34a5eda434c083282ad401b2b85adb05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77cc9b593adaad2abe75f70159b1c0b6dea0542fa2aafe1cc7474e65ffc9ce3"
  end

  head do
    url "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "mbedtls"

  def install
    odie "bctoolbox resource needs to be updated" if build.stable? && version != resource("bctoolbox").version

    resource("bctoolbox").stage do
      args = %w[
        -DENABLE_TESTS_COMPONENT=OFF
        -DBUILD_SHARED_LIBS=ON
        -DENABLE_MBEDTLS=ON
      ]

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    ENV.append_to_cflags "-I#{libexec}/include"

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{libexec}/Frameworks" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    C
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{libexec}/include", *linker_flags
    system "./test"
  end
end

__END__
diff --git a/src/crypto/mbedtls.cc b/src/crypto/mbedtls.cc
index 4bc16d4..278c524 100644
--- a/src/crypto/mbedtls.cc
+++ b/src/crypto/mbedtls.cc
@@ -106,8 +106,6 @@ public:
 	std::unique_ptr<RNG> sRNG;
 	mbedtlsStaticContexts() {
 #ifdef BCTBX_USE_MBEDTLS_PSA
-		mbedtls_threading_set_alt(threading_mutex_init_cpp, threading_mutex_free_cpp, threading_mutex_lock_cpp,
-		                          threading_mutex_unlock_cpp);
 		if (psa_crypto_init() != PSA_SUCCESS) {
 			bctbx_error("MbedTLS PSA init fail");
 		}
@@ -120,7 +118,6 @@ public:
 		sRNG = nullptr;
 #ifdef BCTBX_USE_MBEDTLS_PSA
 		mbedtls_psa_crypto_free();
-		mbedtls_threading_free_alt();
 #endif // BCTBX_USE_MBEDTLS_PSA
 	}
 };
