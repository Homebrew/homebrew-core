class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.102/ortp-5.3.102.tar.bz2"
    sha256 "71af95cb7e383a308ec7a12aa52442b15d4135ed1168fecf9cccb7411be3da31"

    depends_on "mbedtls"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.102/bctoolbox-5.3.102.tar.bz2"
      sha256 "5332dd2ad7e5b6f8e944d2fc002b72b0ed40a8210df1cd76e5f5458cff26adc2"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f8451964417d977ab4d252ca416e76ede9e4294b4de92f5d332d19a74cbbd14"
    sha256 cellar: :any,                 arm64_sonoma:  "693b5e8a276e4b5f65324d81f61b0bb1560bd2516cbafd59387a695953c74bc1"
    sha256 cellar: :any,                 arm64_ventura: "ca57c1f9302f1209f5ebfaba01ca595262ce31153d26e72d7d97a0379ce39f98"
    sha256 cellar: :any,                 sonoma:        "563ab223194134cc1423253447783bc8fe89f09c563e061f5ec8d19a4e3a0fa2"
    sha256 cellar: :any,                 ventura:       "e551562d4d9a4a7b0cd9842b5e41aaa0d53c35e888d1b3fbae1629fb54fc5caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e733b02f34a805627c255b8a16f02070b55a804ddb054cc16069066bef762895"
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
