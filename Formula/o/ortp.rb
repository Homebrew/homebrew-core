class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.85/ortp-5.4.85.tar.bz2"
  sha256 "038baf8f81d01f2ed4c670e6852609fe3007d7885f744be3e9a4e98548f7f96d"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47667fb800e0fa03c48c07c0a22a866262400b96cdfd0271474a2d22c11489f4"
    sha256 cellar: :any,                 arm64_sequoia: "5bf21becf75ff115f316560a3a9efb433d8aee1cafc5e231192cc81c76b8803d"
    sha256 cellar: :any,                 arm64_sonoma:  "d22dc679d1160ad21b7336ae102d483208d1552d90260be976205b26dc509c2f"
    sha256 cellar: :any,                 sonoma:        "a55739e7c970d92559ed07e6811b037991334901b2c839355b202d43ed1cf37a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "009b265af70f8cece74f0dc55f41b0e35b067712f49d08a4c5cb72b5c0053a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fd28f02e35d41ad3ba9295e9990ed5fbda8acf28a5f04c07b199fb09c9fc89f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.85/bctoolbox-5.4.85.tar.bz2"
    sha256 "d8edb697d5a3f64ad5b759d72617054a4fad1256561ec1eca3ecdd61bad3038c"

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
