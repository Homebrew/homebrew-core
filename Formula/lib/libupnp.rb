class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.2.0/libupnp-22.2.0.tar.bz2"
  sha256 "7e7e3eb1c1c192710e0ca39180195acf7a03a80bd1f94fd0ad952a44c1f80dcf"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9752b98a0ebbf922b101928ab1676cdf7e1b9b8528e0189ebf81136514203ac7"
    sha256 cellar: :any, arm64_tahoe:       "7c9c552c39b81f7d8d5349369024e32e1298ce5dddebcb3eb07ef6e3d0ce1c27"
    sha256 cellar: :any, arm64_sequoia:     "1f1197f7921be0a7b4a575e35bb5a1d7b63346111e90b79cd23898a78129d0e8"
    sha256 cellar: :any, arm64_linux:       "2a95846eeb204a474d4019a645b9372b4754d4b91ba271c924b5064401205b47"
    sha256 cellar: :any, x86_64_linux:      "f7b579e69a3adbec8d2db5c77bce1207baae4772979a94f01343e2c9e2163716"
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
