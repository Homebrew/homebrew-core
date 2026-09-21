class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.1.0/libupnp-22.1.0.tar.bz2"
  sha256 "238fd87f7173c1125dedd553193983c58a91d7fb1179358523cfe4fb2731577a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6baf17bf6948ac0ac9a83f505b102c2af3e756a5fc3ff9ea3963db9e0fbead76"
    sha256 cellar: :any, arm64_tahoe:       "6c7e0b620645be557180652e91b878e39f32aeff11a29634cef9068f208e91a7"
    sha256 cellar: :any, arm64_sequoia:     "ab50cab6b010798a2c2b79f05066a8942d944b0bb02309b98ffd5c98ab8cd54d"
    sha256 cellar: :any, arm64_linux:       "8d6240be036585524e17119abbad5ed93cd06c32b1a236d0672ce31e0f06a3a7"
    sha256 cellar: :any, x86_64_linux:      "ec29933d5b1a426633d465a74dde504bdd6c474ae86ce54985865a54cb5b5553"
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
