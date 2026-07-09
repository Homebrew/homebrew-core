class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.11/linphone-sdk-5.5.11.tar.bz2"
  sha256 "1aa33617517f61ec042421b6c79c170d5b5434282d3da7038bcc18516c29a831"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f32f5e2d0b16e973959b1ec239abb79439cb56c6462f0b3c05d7e35d219bce9f"
    sha256 cellar: :any, arm64_sequoia: "940fb859e29b6581c9d9a37f1a50e6d1fb61b7a27b8e42ff152307d575d67801"
    sha256 cellar: :any, arm64_sonoma:  "37d74f15957846b454f31df3e26af5362a4f0db7019fbdabea23b4d724eea1b4"
    sha256 cellar: :any, sonoma:        "8c37d812db869497eaf4a4a59de105cf423690ce2d0451938c33d6217031dfec"
    sha256 cellar: :any, arm64_linux:   "c4de723b41be381d5fb62a872b0b96fbe1b546be0ba2a4b972a8ed6f19eea8c9"
    sha256 cellar: :any, x86_64_linux:  "e5a7e98b3e7b86e7e4f8a04948c02a9378f503d263a9ef5227b27dd60b7a915c"
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
