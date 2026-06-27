class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.8/linphone-sdk-5.5.8.tar.bz2"
  sha256 "31cc6c2e77ee25ce1127f6b2cc210ed7dd0cd2c98a2a915cf8164f106f2bc4e2"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fe86617e4db05cc40132267dac2e38ed24d9cc46ce721e719f90c8e35c8e7f5a"
    sha256 cellar: :any, arm64_sequoia: "a2a8416dcaf56c6a522957c343d51f18730f337e107096440acd20350a383f40"
    sha256 cellar: :any, arm64_sonoma:  "45333fd3bbcd8d747fe99b9681a68253661f878fed3bb841ff023a35f75b29b1"
    sha256 cellar: :any, sonoma:        "19e655ac274195d449b16e6e61374eeb47e67cd466f707a78fe84d40ad621d32"
    sha256 cellar: :any, arm64_linux:   "e334d9b028117955340278106f90d6598374aaaa70c95f59b7cf531a0157a3cc"
    sha256 cellar: :any, x86_64_linux:  "503a3c0b65e63d9339854b6f00d81127f60173c59812922efc9fc38fca1538b1"
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
