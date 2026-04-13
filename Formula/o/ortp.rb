class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.106/ortp-5.4.106.tar.bz2"
  sha256 "b0ed2364c82d900cc5e76008dde9ceb8a81abf3c52c9212bd4572a43f4c48074"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a41a3124737984c11df93e390e3de390add39c3f60137eb323517eda57029cea"
    sha256 cellar: :any,                 arm64_sequoia: "fd6645a012809b2abb557d78943fd791cfc31113a47fa9f471d51a7f3dda9282"
    sha256 cellar: :any,                 arm64_sonoma:  "a77812dafd398af85ebb15f1866e9ee2d7dd534d14b5107b218d0f88b7473ff7"
    sha256 cellar: :any,                 sonoma:        "63f5ee8e882b0d5e8ccc6e161859b3c432fbf59c66304d81733ef201f3784f8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d09bf43445802d9aa3b7aeec9e36f6ce453d9fed01687c298c4bd1057be026ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3541b57f20a326913d7e56adbe5c99711fd64e7fe511a9c823bf7982f832eb9e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.106/bctoolbox-5.4.106.tar.bz2"
    sha256 "d45d73b3104799dc608c4860e40f910cad596bf7f7b7dc548567c1a928dbd42d"

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
