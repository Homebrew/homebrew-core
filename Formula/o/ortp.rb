class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.18/linphone-sdk-5.5.18.tar.bz2"
  sha256 "a01e94d091cedfe81a46fbb72340505036758a0dd62026e0bbc27d5ff27a8f88"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ec4f268d7bbfa4af0d92605fc2e4302e653fd21ee4a7d669bc34ba706a3398f2"
    sha256 cellar: :any, arm64_sequoia: "6aafc3785ef52a52b470d1bfe0b90f469706302ddf4f5591b897fb956b1b5158"
    sha256 cellar: :any, arm64_sonoma:  "2f2d95509d57ba7749d82a17e31e936ccc7514045719c206535a7104a6dabf27"
    sha256 cellar: :any, arm64_linux:   "389fd11dbf7a13fc9f03137e8d2c487e8cbde35095d0707f37269390abd1cee2"
    sha256 cellar: :any, x86_64_linux:  "e871e43d73f3ec3e2513762c69fb868f1ae5721618a58cbe562327e20ef74c6a"
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
