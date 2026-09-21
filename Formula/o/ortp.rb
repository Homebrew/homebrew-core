class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.23/linphone-sdk-5.5.23.tar.bz2"
  sha256 "8c7f255e50e0b9f4a09bb2c4796d0e8ff5abdbdd13fe4c10a94cca9c2278c8fa"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a300739862ed710bcc5106a7dd5d8f56e91aca14e6424913fda5be5ff78e50d2"
    sha256 cellar: :any, arm64_tahoe:       "49b1ff892c047cbfe0761fcc10a26935daa01847a05f3989ec5519b0db2e9118"
    sha256 cellar: :any, arm64_sequoia:     "e66e4b1d3377eb88c0b7e88cd3c9d0413ef65363b44cf6d0c214cadbe679daf4"
    sha256 cellar: :any, arm64_linux:       "2359d8509d0f81a4c8d8df801fbb8e137ae4fb297b5d4eed0af6612cc47eb62c"
    sha256 cellar: :any, x86_64_linux:      "74ba543edd8293a64a85999be64a31664f5ab4bf1260a42aa3f305a32020e477"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3" # OpenSSL 4 is not supported in monorepo

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
