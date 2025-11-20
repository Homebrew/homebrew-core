class Openmama < Formula
  desc "Open source high performance messaging API for various Market Data sources"
  homepage "https://openmama.finos.org"
  url "https://github.com/finos/OpenMAMA/archive/refs/tags/OpenMAMA-6.3.2-release.tar.gz"
  sha256 "5c09b5c73467c4122fe275c0f880c70e4b9f6f8d1ecbaa1aeeac7d8195d9ffef"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^OpenMAMA[._-]v?(\d+(?:\.\d+)+)(?:-release)?$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5702a64103b3c429d8d1499aedd50c032b572b3ba6c748f185cf2566a3fdf390"
    sha256 cellar: :any,                 arm64_sequoia:  "786b187f472ddd357f105cffc281cf4f8382b46ae31c5b428a5f1d8038c812ae"
    sha256 cellar: :any,                 arm64_sonoma:   "7b9ff5f5a5bacec5396c90a71d3f473c917aa5bf33cd403cc6f5eb4259f5f8b5"
    sha256 cellar: :any,                 arm64_ventura:  "6de6d6508390baa3544fa1995f827b8bf9cd6e043d167b97411e4fdf1a82c2d5"
    sha256 cellar: :any,                 arm64_monterey: "01798a8ef79a4568217feef635bf6c19a611df734fca69ca1d056a15ff6c8708"
    sha256 cellar: :any,                 arm64_big_sur:  "035ce67cd9725c533fd499fb06cb71bde602a6fa166ebd5ee1d4895e39dd9c09"
    sha256 cellar: :any,                 sonoma:         "d42d95ddea2a041378fa8394830624d124c4703c371a6957da3f837676f27562"
    sha256 cellar: :any,                 ventura:        "31d87546029420927fd22a57abb347c9e90886cdc3d1b53d835658100fd3f302"
    sha256 cellar: :any,                 monterey:       "411572b9bbc3d14e3ed1fa4037fd1a8cce714111b8557a2771f810408e263170"
    sha256 cellar: :any,                 big_sur:        "b0484f0ae2366f8c6170164c8067f42dd0f94a9e0afaefe3dc68924c4a57cbe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a4ecfe08949d2b93113900c434389b2e662998c0dad4a23e76150dac15a53f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62da575388fea1bf4abd1799475004e328344c01351504d33c61aac0de464e46"
  end

  depends_on "cmake" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "libevent"
  depends_on "qpid-proton"

  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  # UUID is provided by util-linux on Linux.
  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      -DAPR_ROOT=#{Formula["apr"].opt_prefix}
      -DAPRUTIL_ROOT=#{Formula["apr-util"].opt_prefix}
      -DPROTON_ROOT=#{Formula["qpid-proton"].opt_prefix}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DINSTALL_RUNTIME_DEPENDENCIES=OFF
      -DWITH_TESTTOOLS=OFF
      -DOPENMAMA_VERSION=#{version}
    ]
    args += %W[-DUUID_INCLUDE_DIRS=#{MacOS.sdk_for_formula(self).path}/usr/include -DUUID_LIBRARIES=c] if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mamalistenc", "-?"

    (testpath/"test.c").write <<~C
      #include <mama/mama.h>
      #include <stdio.h>
      int main() {
          mamaBridge bridge;
          fclose(stderr);
          mama_status status = mama_loadBridge(&bridge, "qpid");
          if (status != MAMA_STATUS_OK) return 1;
          const char* version = mama_getVersion(bridge);
          if (NULL == version) return 2;
          printf("%s\\n", version);
          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmama", "-o", "test"
    assert_includes shell_output("./test"), version.to_s
  end
end
