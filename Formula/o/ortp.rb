class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.118/ortp-5.4.118.tar.bz2"
  sha256 "f11d84a88ee015ef935a9510072d92dfa6f3fd155e404e35c0ff3ab935dcf3b1"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "990f5ec920949cdb5441a94cbbd65091293e01afff24d265f8089ddbdbd46704"
    sha256 cellar: :any,                 arm64_sequoia: "54d7050325e27693e373b7a0f76ec6f8ff784209b9978cdcf2a5b3781d557b72"
    sha256 cellar: :any,                 arm64_sonoma:  "4e3594d665779fb7d30a06add1364f4d6470bd0f63e5741a84cb556d40761435"
    sha256 cellar: :any,                 sonoma:        "7a506d5e4d8930f8f6197fa499bbfb836d37f00c7fd39d5cb7cfffc42e1a5e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf24433252f077a5b874bba013cd689eb417fef97d6a09ca9a17d6193c3d2a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e14680f41e1c6e5b104ea06f6a9b30d3fcb55a10ac63475933bf89e417cbbb1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.118/bctoolbox-5.4.118.tar.bz2"
    sha256 "74d6e2b3463868cde675dce622172403939938fc9a9239ce8cc2c801b1a4d705"

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
