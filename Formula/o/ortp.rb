class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.0/linphone-sdk-5.5.0.tar.bz2"
  sha256 "94032dbf87ea0437000571c7c96835d916869914b99d1478fa8c847109750e82"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bced56eb5e9fbaaee53d83e7d86139c511a0eae4df62b67e94a274a2750be52d"
    sha256 cellar: :any, arm64_sequoia: "471ea824d8ee0104bb69dd7c635e1b2c32f6d4dbf1a748a9090601aad6eb1f17"
    sha256 cellar: :any, arm64_sonoma:  "9734c6a2869245a75bc7cbb916fe6cd251c6e93dc6683012a56018c62d7e43bf"
    sha256 cellar: :any, sonoma:        "df03bd3c667cd905856a520ef4a111c6891b6f38cca9aa76723e592d30a04c9e"
    sha256 cellar: :any, arm64_linux:   "a0a2b76e5324648c88170b03599f71f6c2ffcb497e3fc2eedd03d199f2f082ad"
    sha256 cellar: :any, x86_64_linux:  "9322d0fbc4c8e07b4de8c3f3b31a6a62b5e3206333245427e5afe5642d265b96"
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
