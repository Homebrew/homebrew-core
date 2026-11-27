class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.44/linphone-sdk-5.5.44.tar.bz2"
  sha256 "a27c8317d0e2b4277d0ca060bb6b551b380af9b79eeb13ebb3f8895821449f56"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    manifest_sha256 "fd707fe59662ba022137407029187252cce6aa4e3eab1acd8d547989bf395e11"
    sha256 cellar: :any, arm64_golden_gate: "efaf398a72a0a14391554cca4628bad648fd630cc2ae57079209b1a461b66fae"
    sha256 cellar: :any, arm64_tahoe:       "757f09b409b919b306fc6ed1b04b79a04dd9153a4f92e03672fbc9c10983844d"
    sha256 cellar: :any, arm64_sequoia:     "a15aa78c241bc69c8b938f0d8fe3896bdefdeb635bd260ce283d32b2beb4c605"
    sha256 cellar: :any, arm64_linux:       "d8cbfd99b2fd51c3913d0ee945bd7fe4c61fdc61e0e07bfe639129c718b5e3c4"
    sha256 cellar: :any, x86_64_linux:      "3daf4803eeb5365e81dd6081688f6f10431b7e0b7c22b08ebc7c4e7eb4adbb27"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_MBEDTLS=OFF
      -DENABLE_OPENSSL=ON
      -DENABLE_TESTS_COMPONENT=OFF
    ]

    system "cmake", "-S", "bctoolbox", "-B", "build_bctoolbox", *args, *std_cmake_args
    system "cmake", "--build", "build_bctoolbox"
    system "cmake", "--install", "build_bctoolbox"
    prefix.install "bctoolbox/LICENSE.txt" => "LICENSE-bctoolbox.txt"

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=OFF
      -DENABLE_UNIT_TESTS=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{frameworks}" if OS.mac?

    system "cmake", "-S", "ortp", "-B", "build_ortp", *args, *std_cmake_args
    system "cmake", "--build", "build_ortp"
    system "cmake", "--install", "build_ortp"
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
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", *linker_flags
    system "./test"
  end
end
