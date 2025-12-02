class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  stable do
    # TODO: Switch to monorepo in 5.5.x
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.65/ortp-5.4.65.tar.bz2"
    sha256 "4ecee5c64b60c8e0b34f6c44cbfd022705d5a06bddbb010e442c4c5503e7022b"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.65/bctoolbox-5.4.65.tar.bz2"
      sha256 "0cb41b759b19dd24cf29847c2bcf96ac0c68cdd210c0b0ba862d43ebaedb35f2"

      livecheck do
        formula :parent
      end
    end
  end

  no_autobump! because: "resources cannot be updated automatically"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b34c76a2b6c6402c5451556d32593df1093820f0a31716738f93bb493008087d"
    sha256 cellar: :any,                 arm64_sequoia: "0c29edd8a9da07e162e053064e543e768435055cc836854025417ca5e02b0610"
    sha256 cellar: :any,                 arm64_sonoma:  "1095e20896fdf6f7b536105f4c7ac70cf396438ba46a9baa1b930de2b980069e"
    sha256 cellar: :any,                 sonoma:        "cfae74b62d03aac89fa18c2f530b24317d814ce98d266f3d894bbc066ceeed89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4142d57d7aacf74603c979a427620c03d0e9cb5281521b2acdb3110c94777c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e033762038c4b25e371fbe23ff64be5d9bf08216809663182fe4b8f55156903a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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
