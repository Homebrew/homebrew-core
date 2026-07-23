class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.12/linphone-sdk-5.5.12.tar.bz2"
  sha256 "adf5713ca79d0cab542e308a76ad0ee472f63313e2213c3e34d3f17021d90a65"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e0388aa21d68c23feb32f1d8301f69a7e5ec6b2bf6d4ff85d4baa56b7041aa54"
    sha256 cellar: :any, arm64_sequoia: "626ec8111227b5422d39172387a88a04ffebc5bc09cd1de77227939ad5592eee"
    sha256 cellar: :any, arm64_sonoma:  "b7a3070077a470b570c9712a86e579a1d21542634f7eb6d022db8b6a26c1c160"
    sha256 cellar: :any, sonoma:        "538352c76e5a548c895dfd084a93dda8e29b3ec163c337b6bca8d683852daab7"
    sha256 cellar: :any, arm64_linux:   "add89d1b2eb41e9262119abaa4cd0914aa8c6518b0bd9f5a08c74004cc600163"
    sha256 cellar: :any, x86_64_linux:  "f23065de36cf2df3f0f5d827c92142901330f7e13f1d54eac43e14e0338267e8"
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
