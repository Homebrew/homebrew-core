class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.16/linphone-sdk-5.5.16.tar.bz2"
  sha256 "a97d0155c5607db9579eea23e259ee474c6450c9c3bff384a9156ddff79aee9e"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0c86ce561490ec7c586f3a98d8464e7c612b15ffe1bd80e5dd5c05e36bfab81d"
    sha256 cellar: :any, arm64_sequoia: "6e1736869c687c5fd77bbd7163be2826f30ffe4cf781ffa51b51c2c4c8a2f24b"
    sha256 cellar: :any, arm64_sonoma:  "d17482d22ee78bfa803f0c24e8d357c8db7b695b4f7e8106ad788cb5c07b07b8"
    sha256 cellar: :any, sonoma:        "29f0a1d11c64116c2ceffefc16162c60fb1cd64c913e299e5914c975c568dda1"
    sha256 cellar: :any, arm64_linux:   "a1ed4efd9ff85a185ebd075526fd9b4986c215bf317c65c48892b6813bd12e0b"
    sha256 cellar: :any, x86_64_linux:  "a5fb27ed37e3737ba932662a94d3e5a49f51df01a7e81b65316bd18f08544a8d"
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
