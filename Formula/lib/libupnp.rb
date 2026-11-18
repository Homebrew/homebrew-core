class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.2.4/libupnp-22.2.4.tar.bz2"
  sha256 "3beac41548eac76d22633724d13324a391cc656c6bcf070ed9957abb87efd2de"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f4b0ae309b376a09e6d9d5005702d218f09a2ad685bf75f60f840c4aa60b47ee"
    sha256 cellar: :any, arm64_tahoe:       "279f4ae1a13b37c8fc7b4306daf4f3825e5c99890bf78484622728f536c8ad34"
    sha256 cellar: :any, arm64_sequoia:     "b46923afac99d576e49641ddc59bee28b7a5327bcf5caf6f8a19d025f2987a9b"
    sha256 cellar: :any, arm64_linux:       "4a2dc03e7c26707e87e8fe24e3554b580aa797e21416e81c2e17d946dfc628ca"
    sha256 cellar: :any, x86_64_linux:      "50dd581bc9b5af4c2242aa8dadf75bff35fef3fa5f60fc28e2e4809a1c4307c3"
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
