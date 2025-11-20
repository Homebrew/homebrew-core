class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.60/ortp-5.4.60.tar.bz2"
    sha256 "c5368ff08b22c789a3d94613fce5d20e7b98c3b795663e4d9f56bc5f57ea35bb"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.60/bctoolbox-5.4.60.tar.bz2"
      sha256 "c3585e63d776242dd4cc9588ae6ea625fb53ee686022765ee94ae16bf99e3b25"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  no_autobump! because: "resources cannot be updated automatically"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee7c4366379cd49b757bb2038e58f07c07b7e45085537ff646919750b34709b5"
    sha256 cellar: :any,                 arm64_sequoia: "1c3b5cfeb4cd8a6a9ef659b5ee4bed7919bb50a5291bd0424bfade2c108f1937"
    sha256 cellar: :any,                 arm64_sonoma:  "3fdbbb1db21dc8deb5e27ce1802874ce99abf31ed25c92007416dc919efe18bf"
    sha256 cellar: :any,                 sonoma:        "b9e55c3feca982499ae4d4d7d63947ab537574ae09e436b2a651df3c804a87aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e02f0769c5b473459599ba3c53750d8ed6e607420ae949b34768c2bb65482b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68fa341323afd9377c3051772886e81596d5e720fbdd5a5751d4e8999707b017"
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
index cf146fd..8886b2d 100644
--- a/src/crypto/mbedtls.cc
+++ b/src/crypto/mbedtls.cc
@@ -80,8 +80,6 @@ public:
 
 	std::unique_ptr<RNG> sRNG;
 	mbedtlsStaticContexts() {
-		mbedtls_threading_set_alt(threading_mutex_init_cpp, threading_mutex_free_cpp, threading_mutex_lock_cpp,
-		                          threading_mutex_unlock_cpp);
 		if (psa_crypto_init() != PSA_SUCCESS) {
 			bctbx_error("MbedTLS PSA init fail");
 		}
@@ -92,7 +90,6 @@ public:
 		// before destroying mbedtls internal context, destroy the static RNG
 		sRNG = nullptr;
 		mbedtls_psa_crypto_free();
-		mbedtls_threading_free_alt();
 	}
 };
 static const auto mbedtlsStaticContextsInstance = std::make_unique<mbedtlsStaticContexts>();
