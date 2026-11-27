class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.45/linphone-sdk-5.5.45.tar.bz2"
  sha256 "75a0a8de86e1741bc3ac489474be1a7a3203899114a9df7e509123dc67334839"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    manifest_sha256 "4566401a802050cc33b5e76b817850491b607191e623eff2a8cc2b4fffcbc43b"
    sha256 cellar: :any, arm64_golden_gate: "df3b1e4cf4f7aa5ad029a3912e1ee5f59267b87bb240424ab72891bbd3e7e1dd"
    sha256 cellar: :any, arm64_tahoe:       "dc3419540ed68e20e7e5d42580f004a43158aefa3bf091670557e37d76ebe1d3"
    sha256 cellar: :any, arm64_sequoia:     "4a04414b494048bc3eec46ece261e75ee958913f76394d46defc2fae241c25f0"
    sha256 cellar: :any, arm64_linux:       "ab8ab46146bf757198199c9442df26a578e3ce2fae4704c19a7a9ed5a98d7319"
    sha256 cellar: :any, x86_64_linux:      "26c5402be08df3bfbfafe5164b00c3eb49d8278f83702564558eeee162740f45"
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
