class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.0.6/libupnp-22.0.6.tar.bz2"
  sha256 "7f4e1eed75d904180b705570c8c55d70a47885e46f702f4b96e4fac03159f5d7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "709e1b38de1458344a66a9514ef781ae01cd56c079f47b6b5eef380dcd61d081"
    sha256 cellar: :any, arm64_sequoia: "396f29483e587e808011ea807b90a8497fa1ac15c693166cb933a581494ed9fb"
    sha256 cellar: :any, arm64_sonoma:  "6043d90ab3038ab11a6dbe3bbe63cd98e575b819c377aed4be857ce7d3913267"
    sha256 cellar: :any, sonoma:        "ae27f41d52f35415a1a6374d94cde38e5dea81f9f469b1fcffc8b946f5c57b88"
    sha256 cellar: :any, arm64_linux:   "670fd1b2a032669bf488eccc3d8b839b057a64a8569f9d487bd406bd575345be"
    sha256 cellar: :any, x86_64_linux:  "601c2c78edcca17dec53a46daa924fe36bc846718a6a57f3ffeebb35ec9c7720"
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
