class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.106/ortp-5.3.106.tar.bz2"
    sha256 "16692af175836d9e38ff79065b69aad0d63b7af0ea79c7fac48c3f1578af2529"

    depends_on "mbedtls"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.106/bctoolbox-5.3.106.tar.bz2"
      sha256 "eeebad5333aaac08c522fb8dc077188901047f9fba1fb8845ac14d4fafbb48d3"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f8f3f3f19a0ad3188e6d17b9ea1f05b00e2197acf20faf1c31650b2dc0e5c7e"
    sha256 cellar: :any,                 arm64_sonoma:  "1ca2655a406bd666264258133aa2daa1ba13da7eb40e5b87456f2e4e1bbab3cb"
    sha256 cellar: :any,                 arm64_ventura: "d01444c40490aa5c160cd4e366baaee03ccf19e70ce2d76e7cfac3c986ff0a50"
    sha256 cellar: :any,                 sonoma:        "13473cbdc344bd58d11909bc16a96aaf9184154afd3601c3f38baef2335c1550"
    sha256 cellar: :any,                 ventura:       "7c507970fd4811989e58f9deb7b78ddfa4bd4189d13548e093ba46b580bc918c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9548b5209e7ba21afb45c42bf34622846c0ff8a192097bc32208d759f7c4be04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad54474538903687f1490d96b8a583274bce61120dba8cf71189c3662219fe8d"
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