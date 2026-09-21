class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "2a8cbf13719618d879464617512a80fe2c13fe63cd5461cf01a195fbe46b3ca4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "526f978c2a39f46abeb4f129135ae8f466a224fdc84bebd4b35a78a91f4a72f1"
    sha256 cellar: :any, arm64_tahoe:       "7c9675c05835fdbd4f376766c1b1ad3ecfd9391d169b4b453fd8d29e080b0c5c"
    sha256 cellar: :any, arm64_sequoia:     "3a57a3202d4ae5c0cd09ffab46bdf88ae9e2744e35dace9f3d36a485e9aacbba"
    sha256 cellar: :any, arm64_sonoma:      "1fcc089c63d1547516603517ec686e8c739fafa095d32ba9e2b1cd5588672976"
    sha256 cellar: :any, sonoma:            "56bde52ca922812b73a17dd46ccc379669741587f4e87d8df8514795205e4687"
    sha256 cellar: :any, arm64_linux:       "cda723e5a2807fdd0a7109128f47dba4b7e129e74cac14100e58f75536aa8cd3"
    sha256 cellar: :any, x86_64_linux:      "3f9a884f906877c1c7573e4ef63391291c45613cc9b33e69fd94fed6bcbcfa01"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{include}/re", "-L#{lib}", "-lre"
    system "./test"
  end
end
