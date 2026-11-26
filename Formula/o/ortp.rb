class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.43/linphone-sdk-5.5.43.tar.bz2"
  sha256 "a5d2005c0da2ff4d7b7fdf2753648b18a3f1feb09d26c646427f5a7c695b28e9"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    manifest_sha256 "67136bc34d7b85adfe2e6c9e8948a92e1afa89c88be008a0916054611e9d22e0"
    sha256 cellar: :any, arm64_golden_gate: "ad2f73682d3c7547c86f1660d8b449ea779bbe0597c4458d3baff8bb26bef79a"
    sha256 cellar: :any, arm64_tahoe:       "eadc296b3616d4b387ef055a927520e56f3f20648431a0a0c6fb228ef1a5b183"
    sha256 cellar: :any, arm64_sequoia:     "6ede05a16c95c2aa293e86f9424533ceb9e1826b5457ad5c273c7bca70021ad7"
    sha256 cellar: :any, arm64_linux:       "fa74465c233468433e0cd2e584fedf5a6ed811c38c41df92017d59f0b72fedd6"
    sha256 cellar: :any, x86_64_linux:      "16952d551ae3a3eb39717aa43b6fc7de0eca2b1e33edfd52c71e336977271019"
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
