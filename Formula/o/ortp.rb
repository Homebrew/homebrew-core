class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.42/linphone-sdk-5.5.42.tar.bz2"
  sha256 "627f70d9784e632c7ea9a6fb0aa7e4bdb9e89535058a9fe6277bce8e5b7bf7f2"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    manifest_sha256 "a6696a4df1a6f88e779891e638e1500fda94578e07386b91cc6bc86ccd9245fc"
    sha256 cellar: :any, arm64_golden_gate: "05ea0d73e03dfeb213bff7b51a7455ca9dec2d44056a1fe96ffbcbb65d00f0d7"
    sha256 cellar: :any, arm64_tahoe:       "74629d046e5583e8f8516ef05042f17cb894733f9dec4f079d8e8f6f97563885"
    sha256 cellar: :any, arm64_sequoia:     "6f778e6ce585168a12f39c171c499a6e07ad7d0d188d96d1443c7c35bda7a41b"
    sha256 cellar: :any, arm64_linux:       "816549b253daa111b0a5f5fdc512cf6d309eca59a77460fa4fef3f38c54679de"
    sha256 cellar: :any, x86_64_linux:      "f25fb7ab07a5df05219fff9bb17325c054bb7e2ca932f520af0448a0a4e372ed"
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
