class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.2.3/libupnp-22.2.3.tar.bz2"
  sha256 "d545f4fa58d52582cac39527c0b1a135745694dc31035f6ca8883413c1695ae5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ddd94347ef66427eff8c50ff42de91dc473cc4d723d5ed5cd86767464036176b"
    sha256 cellar: :any, arm64_tahoe:       "16cd71c9ed3c728b7b35c5cdb6f1fb414ba8c9a7270b11b1bdfeadf47caed328"
    sha256 cellar: :any, arm64_sequoia:     "bb3f55eaef06d292f341f8719ba48cd36ed1055461ce9eb3c9854adcf4e3355d"
    sha256 cellar: :any, arm64_linux:       "ae8acc4a4ae9c7badb016ae3f9d8564ff7f845bd13b3baf1ec110d636619ee65"
    sha256 cellar: :any, x86_64_linux:      "cd2174c560414ef1c8a4c04b56980988d216100362c9f52b41295f5c13548605"
  end

  depends_on "cmake" => :build

  allow_network_access! :test

  def install
    # https://github.com/llvm/llvm-project/issues/65557
    if OS.mac? && DevelopmentTools.clang_build_version < 1700
      inreplace "upnp/src/genlib/miniserver/miniserver.c", "switch (gMServState)",
                                                           "switch ((MiniServerState)gMServState)"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUPNP_BUILD_SAMPLES=OFF",
                    "-DUPNP_ENABLE_TESTING=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <upnp.h>
      #include <upnpconfig.h>
      #include <stdio.h>
      int main(void) {
        printf("UPNP_VERSION_STRING = \\"%s\\"\\n", UPNP_VERSION_STRING);
        int rc = UpnpInit2(NULL, 0);
        if (rc == UPNP_E_SUCCESS) {
          printf("UPnP Initialized OK\\n");
          UpnpFinish();
        }
        return rc;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/upnp", "-L#{lib}", "-lupnp"
    output = shell_output("./test")
    assert_match "UPNP_VERSION_STRING = \"#{version}\"", output
    assert_match "UPnP Initialized OK", output
  end
end
