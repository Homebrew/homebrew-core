class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://github.com/drowe67/codec2"
  # Linked from https://freedv.org/
  url "https://github.com/drowe67/codec2/archive/refs/tags/1.2.0.tar.gz"
  sha256 "cbccae52b2c2ecc5d2757e407da567eb681241ff8dadce39d779a7219dbcf449"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["v1.03"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ab0628f64e6690a8fe3d8a0de9920fd4bcd4946b33789eaa2cff468605a20805"
    sha256 cellar: :any, arm64_tahoe:       "308f2acfaed2fc56992a4764a2aabc09a2d82148597e31449f3b56243b8fcca2"
    sha256 cellar: :any, arm64_sequoia:     "95c3aca8f5f5d196313b21b8b888783754f6ec51f4b82a00b9016505a5686cf4"
    sha256 cellar: :any, arm64_linux:       "b09a64a679ce1d1de6c7c07efc418970f11d15653b7785947bfb107091988cc3"
    sha256 cellar: :any, x86_64_linux:      "dcc7730264fac89b75815621a6b8d97d8d3dfdf7576382c930e5631f3a1cde90"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  # Fix include dirs in codec2.pc so `#include <codec2/version.h>` in codec2.h resolves
  # when the prefix is not on the default include path (e.g. /opt/homebrew)
  patch do
    url "https://github.com/drowe67/codec2/commit/8241e30b7ca8784cfac6450b5c84c5b8722c53d5.patch?full_index=1"
    sha256 "e80197819d2168ab88aa455f406d24274bd2e79a42488dce44a754ecdcd79665"
    type :backport
    resolves "https://github.com/drowe67/codec2/pull/49"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "build/demo/c2demo"
    bin.install Dir["build/src/c2*"]
  end

  test do
    # 8 bytes of raw audio data (silence).
    (testpath/"test.raw").write([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack("C*"))
    system bin/"c2enc", "2400", "test.raw", "test.c2"

    (testpath/"test.c").write <<~C
      #include <codec2.h>
      int main(void) {
        struct CODEC2 *c2 = codec2_create(CODEC2_MODE_3200);
        if (!c2) return 1;
        codec2_destroy(c2);
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs codec2").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
