class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.2.1/libupnp-22.2.1.tar.bz2"
  sha256 "11ac0f670aad96bd9c81cc84a6d4ae874a7b4b11073d5b88a03fd43efd097cc6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a692fc1e9b31264fdd3fa10658534e8c0bda733cef128e123e5da3021c89b883"
    sha256 cellar: :any, arm64_tahoe:       "c145e47f21bc727898c43d7b2193c2fd3f8ccdc0a205625c48b2e13cdf825d53"
    sha256 cellar: :any, arm64_sequoia:     "abc41805bc7a09a8f2607ef64f02431c65703e73f6e7526f48fa16a8671d1edd"
    sha256 cellar: :any, arm64_linux:       "7c93cebcc0362e1268c3569d0d49157a6603c23be7588a5825c9af6e3dc41a08"
    sha256 cellar: :any, x86_64_linux:      "ab05c4a7abe5f0e1711c82da81f25990177cb9472b2abbc0eb4d53b107cf37c1"
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
