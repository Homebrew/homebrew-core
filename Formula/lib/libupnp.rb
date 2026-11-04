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
    sha256 cellar: :any, arm64_golden_gate: "bac7e80315db2465809b74fc804112ae5f9b2da43a5bc7deeb4cc8bab1162ec7"
    sha256 cellar: :any, arm64_tahoe:       "1a35e15264d4334886612def0187c1c8d839b0f5cad1a66e0c03cd077ad10f79"
    sha256 cellar: :any, arm64_sequoia:     "1ab62000247c8b5b496fe7d6d8d273cec96229ed62bbdb34059042eda8c97daf"
    sha256 cellar: :any, arm64_linux:       "f0bd76099933643fd0943965d2e2bbe5c0b785cd28310bdcb36ffb41c0cf68e5"
    sha256 cellar: :any, x86_64_linux:      "75533428fe53a1daf7f29e8e3036e14f2b4b9760959d84e5a9644120511ad28a"
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
