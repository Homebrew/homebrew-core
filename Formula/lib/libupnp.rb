class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.0.4/libupnp-22.0.4.tar.bz2"
  sha256 "32d4c6bc7d305a551e596d5014098b70949c4954f64333d1d07771a38627bf37"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "70bef418cdcdd7aaad44c25cbbf214ac3111ab7a83b877a41d79dbe3771932a4"
    sha256 cellar: :any, arm64_sequoia: "5e1928c23e2161327f9370510231c39d714c194267143807dbdc86b506758598"
    sha256 cellar: :any, arm64_sonoma:  "6b55f0744b670b19569570891d2fed55b4fed35946f12aeb531e2cd0be4fc69a"
    sha256 cellar: :any, sonoma:        "c7436824b80b9fbbee0b2a92470291883dbf5f3bda38abb0a74b19560089e912"
    sha256 cellar: :any, arm64_linux:   "e0c2e5f4fd5359f049d5889f6772f7a44afc41b742f363b43f6904838755a90b"
    sha256 cellar: :any, x86_64_linux:  "58d2d5719291804ec94c012af852dbe7b89eebd54fb2e204d21f3bed0e01a52b"
  end

  depends_on "cmake" => :build

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
