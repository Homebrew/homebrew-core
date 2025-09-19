class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.42/ortp-5.4.42.tar.bz2"
    sha256 "9d04bec47f0a5f354d3b6b64b9d941460927408085b644f1e2ff65e3cc16e442"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.42/bctoolbox-5.4.42.tar.bz2"
      sha256 "6332c302ef2c3c56a7755ffa027def31e1f2dc2a037af8aa789715ade55c6b40"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  no_autobump! because: "resources cannot be updated automatically"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07d48e8b8da10f7fe4f7d69781624ccb76701b2e9779425bdfcce688fd85faf6"
    sha256 cellar: :any,                 arm64_sequoia: "506778639c8e163edeee830bb79a72a5390da6b223c95b0b21b2fa167be4d4d0"
    sha256 cellar: :any,                 arm64_sonoma:  "0972aa70f7a4026a9617caf15d05dde152e91c17dfe2d9b0d7e9e7a1b0b1b328"
    sha256 cellar: :any,                 arm64_ventura: "e2e284f968698aa26ff807eb31fed886bcb3da26a2d34714e822e58ee11a9775"
    sha256 cellar: :any,                 sonoma:        "0a3d046716df631d5042bb1f8d5a5aeac52cb4d713274cf2ce8627736f8eb161"
    sha256 cellar: :any,                 ventura:       "fc36c64efd399ffd32e8d67cdcd56e1afa02461bd15522ecaa58ac29a851307a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "580c7573dcd8cba79c72f719e6e88bd5fa9b6f3d955b400166120ad0089fac80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96a0e56ea88cca7905bafae79d6925de68d885a931ea554ea47bc57f93d8e3da"
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
