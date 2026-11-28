class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.2.6/libupnp-22.2.6.tar.bz2"
  sha256 "ffc2695bf47fcc11a2afdcd28fd1cc02c83b64eb9a00ed65a51e2cddd6257a0d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "091ceb68e61ff2f0e783f66cbe0b9dd44cb43dd226d14d319a0207cad30b9f53"
    sha256 cellar: :any, arm64_golden_gate: "167f5f56566ee13e94e964e93cc1cf80a28f027d4ac8382ddcf1614482afd9dd"
    sha256 cellar: :any, arm64_tahoe:       "722bdd215f603311581b1092dbb8e1415e0d064f8853b60aeb504eb94adb73d9"
    sha256 cellar: :any, arm64_sequoia:     "e160d02b57e7ad3eafe0cca8a9237a587768331500dfb02865487afc40a57c99"
    sha256 cellar: :any, arm64_linux:       "4ed708fb58024c8eba41f1ac6f1385f54474ab5cd1300748567b0dda3c6cb0e9"
    sha256 cellar: :any, x86_64_linux:      "7406a34cd5b5b01b4f8f62071320661d3785ae1d1d9a7708152bb2552ada567e"
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
