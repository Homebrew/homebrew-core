class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.100/ortp-5.4.100.tar.bz2"
  sha256 "6cbfc59cc4a14c19322cea18d01d95cf2da21ff66b84f4d940cfc171240727a5"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32032f1ae028dbea0da7a7d4313a3579de16c5c0bda2a6cfb80a01dfb4153575"
    sha256 cellar: :any,                 arm64_sequoia: "2812239d60eb3db4a89ed81d7c05e99a57d9fa7865290ae9701847b31ca75b18"
    sha256 cellar: :any,                 arm64_sonoma:  "e507bad16f12c8e658775556832d1bfa2836e58cd2cae1fcc2dbef8ede00acf3"
    sha256 cellar: :any,                 sonoma:        "a4a97291dcf285f0cf42484cc2ddbd1e5722860fa5975fd011dc54b3fd40316d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bb6024dc172e6773fa170c77367320b03314faa78858c5f0f2f24e7388efbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a9ece3c6a64ccf3339db33cd145608dc1f1d1c187dd5323e9c7a9e8b8be751"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.100/bctoolbox-5.4.100.tar.bz2"
    sha256 "9968bd9379efc6b73a87243ac4ff66a14c3a5e6340a3dbc3e0a5f8d1a87a2149"

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
