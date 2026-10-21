class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.36/linphone-sdk-5.5.36.tar.bz2"
  sha256 "6cba7b689a40b320c416aa30741865d10f839e1ccbcf8cd860cdf1064ae69d1f"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1feae24b6dcf53a6e97bc53cef370f491159d017b99c3fad9500e3041da94b79"
    sha256 cellar: :any, arm64_tahoe:       "556c05e671561ef7a3f1c00d893c1f16a0e423941810e3f585e996a3bc21a3ce"
    sha256 cellar: :any, arm64_sequoia:     "2ede03c7ce688bc138ceb545c4b0f2295bc5425cd98d1b87943a8d38ea508e44"
    sha256 cellar: :any, arm64_linux:       "aca74364e3ea4cf63f7373426fa02af1ebb1a52a70433d7e29729773bfbed571"
    sha256 cellar: :any, x86_64_linux:      "fc05f71e5e379f81bda669f31fa3f25ebc14bf4f618e593e21adcb844ba2bd08"
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
