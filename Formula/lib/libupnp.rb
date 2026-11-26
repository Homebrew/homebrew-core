class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.2.5/libupnp-22.2.5.tar.bz2"
  sha256 "1d690f7ef211017f27b36d79fac7d79a2c0c232d99c44a27bfde067fcdd7dafb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "3194ecca29b7a7ea32a13aca7c9756315b9457d40f282e1b043e1ff6d6a45c80"
    sha256 cellar: :any, arm64_golden_gate: "2e7536cd4c437c14d11307848f68284c934f8a345efe938db2a8f2cf133397b2"
    sha256 cellar: :any, arm64_tahoe:       "367aa6d3f24b34175f067ab7a485f91d958199962509b40f4085f395ca42c28f"
    sha256 cellar: :any, arm64_sequoia:     "c3ebc83835ae8493707ee72bda0b793ba74129698e91ff3f47885d5d48ff2056"
    sha256 cellar: :any, arm64_linux:       "34de799f50de2b636b7d0243e2c54f923cbbfd3d0470a6c09703eacfa71b4cdc"
    sha256 cellar: :any, x86_64_linux:      "a947552a61fb975a76e28bce13b6dc5c89baea9da345ecc353de9e0f6d5fe8cd"
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
