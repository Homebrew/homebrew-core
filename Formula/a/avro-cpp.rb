class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  # TODO: Remove fmt in the next release
  # https://github.com/apache/avro/commit/d77446e5d05cd68c28d09c1af800a428dea34e03
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.2/cpp/avro-cpp-1.12.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.2/cpp/avro-cpp-1.12.2.tar.gz"
  sha256 "5e4cea5d9dc59bbc0e3e1967fd8f8a86b4cb7c1452c4b252561b8137e949f6fd"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "d3f9da71b7a04552306ec72c454aab24080d3be40b0d207f1ca1dabd1d98b830"
    sha256 cellar: :any, arm64_sequoia: "fb3bcc0a37022f4aaf52dbf6293a07b637e2e336c9d3302c202b9638be97e132"
    sha256 cellar: :any, arm64_sonoma:  "98df183ed33d28bcea389729ab3c98db6373870b3226f77e6500551060b322e1"
    sha256 cellar: :any, sonoma:        "a91303d45f45aa816eee305e8a93dc24098eb98e97cdc03ff6e148d6bf6d575c"
    sha256 cellar: :any, arm64_linux:   "9efb3fe4f8fd6ce010daf86042f45c191d8aa1040f4011df89fa9620fcb37d77"
    sha256 cellar: :any, x86_64_linux:  "b7528636985c4d1c8ec42f4f7c75d8082dd173d5e89eb407674f5d2b9e1802ca"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => [:build, :test] # needed for headers
  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Add missing cmake file from git
  resource "avro-cpp-config.cmake.in" do
    url "https://github.com/apache/avro/raw/refs/tags/release-1.12.2/lang/c++/cmake/avro-cpp-config.cmake.in"
    sha256 "0edd19477321eea574be10972f65fc958bd7ae907de1a3974d9bffec238a01e6"

    livecheck do
      formula :parent
    end
  end

  def install
    (buildpath/"cmake").install resource("avro-cpp-config.cmake.in")

    system "cmake", "-S", ".", "-B", "build", "-DAVRO_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"cpx.json").write <<~JSON
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    JSON

    (testpath/"test.cpp").write <<~CPP
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    CPP

    system bin/"avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    system "./test"
  end
end
