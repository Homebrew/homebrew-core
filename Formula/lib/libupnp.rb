class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.2.2/libupnp-22.2.2.tar.bz2"
  sha256 "fdcc16f0167d822a8ba97857eb40edd7991c5aeb97d4e528ce47ba7a62fb517c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "389d8c6424db8f7561e59a14cff9b845c5347405a38901997cf7ac0aefa37976"
    sha256 cellar: :any, arm64_tahoe:       "c81446dccba74adff445bfc53e5988b5abf29ed884ed174874af9bcf249017e7"
    sha256 cellar: :any, arm64_sequoia:     "174e78a254c51305dff4d5325060aeace37f0bf155439daec552ea50ec4953e8"
    sha256 cellar: :any, arm64_linux:       "81d8c0287e53ba279b3c1d47dcad6a71c59af0731415cf095ccd13ad8d08dd44"
    sha256 cellar: :any, x86_64_linux:      "7cca1eb16a152967dbab0c973213a1a8be450745fff67ecb1f27a089fc944745"
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
