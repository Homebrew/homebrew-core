class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.80/ortp-5.4.80.tar.bz2"
  sha256 "ff21708865726f648f232f115e28b3cad6e7ae3c61895ea6c1fb33d92226bf07"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78063b1e312842c8a802c915b39692440186bcac0f4d2bc6763d3f83339ce3da"
    sha256 cellar: :any,                 arm64_sequoia: "32ee60c3f0efb6c20de428da5b488cf8a7ad629afd93c6bcd347157670026564"
    sha256 cellar: :any,                 arm64_sonoma:  "8d041fb2bfb21cf3b86c55bd1ec27ef142f56bde756675d44361702fc5d7befb"
    sha256 cellar: :any,                 sonoma:        "240bf016fbcbb40dc5674ceced1306ad8ca36730c6194da07a5337510eb7a603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfa6b32575dc2e48243836715932c316efa21ca0cf5ba53d824d83168ee4f1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38dc90ba1de2e50ebb336c1cf235e50122a530f82ce95976fb66d4dbc379adf5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.80/bctoolbox-5.4.80.tar.bz2"
    sha256 "6554b1444b16980a78a08572be7c593cca8f7ac3ba922e8edf6a5fe6cca7cb02"

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
