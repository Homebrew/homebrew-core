class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.111/ortp-5.4.111.tar.bz2"
  sha256 "64b17ebe6414a832d16764c7c525e49ba9257815d603e957ac1bcbdca417b08b"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7495584ccbedefb98d47858292393a7c9c477ab923d6966aab19feadc23e3f0d"
    sha256 cellar: :any,                 arm64_sequoia: "0efcd9f68eed0727f3d79f76b28126df3cabc5b4d77ce2fd9a343652b8d95da6"
    sha256 cellar: :any,                 arm64_sonoma:  "a35bd17c90f622d716188574094ebdc68533317ef945225c7ddcf92fb7c7358a"
    sha256 cellar: :any,                 sonoma:        "6cc1392daa1627a343b6cafcf8c61dab240a349ff467f508cf2ce8e10d0c6aa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "495071fcf72c8c26cbf014115b74059130b245df13bf39955065e279ef344f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd01b747824247df1e4d427147511fced3430fdad19a9182a54c8b7ddd0c4648"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.111/bctoolbox-5.4.111.tar.bz2"
    sha256 "cece8936a14781ee5d3c4ed529c8cefc5501e2adf69245435e835c1ed07d1fa8"

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
