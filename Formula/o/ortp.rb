class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.76/ortp-5.4.76.tar.bz2"
  sha256 "6b08db76cf6362404034e67eae95035b7e1602bc30bde86baf7a91fc792386e3"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30d8450449b939652656370547ebccfb89bc4db337596762ed837d5abf379f75"
    sha256 cellar: :any,                 arm64_sequoia: "be06e281b1a7280e79db4cf6b0b7e19c3b0f852dadfac13a1e59767c162e31af"
    sha256 cellar: :any,                 arm64_sonoma:  "facc8dba682c2390011a2df5e6ff92833e205dad9fe60de89048801e34e2a183"
    sha256 cellar: :any,                 sonoma:        "b71320f32a3b9b471796fcf3eac661a02d4853ba033f917575b769ff29e3fa8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e3f8cef1ada3b02bbc9807543135accff58fbd9bb2f73f82367907af9c81b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8715ee295cb3eb3bbaddf86dc394a6ef0ed6f7be91fb94b11531bb7c94ddc52"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.76/bctoolbox-5.4.76.tar.bz2"
    sha256 "6a74b342eef79627d15097b3f779f1f91275d82ea78db58704f4b618ecba7427"

    livecheck do
      formula :parent
    end
  end

  def install
    if build.stable?
      odie "bctoolbox resource needs to be updated" if version != resource("bctoolbox").version
      (buildpath/"bctoolbox").install resource("bctoolbox")
    else
      rm_r("external")
    end

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

    system "cmake", "-S", (build.head? ? "ortp" : "."), "-B", "build_ortp", *args, *std_cmake_args
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
