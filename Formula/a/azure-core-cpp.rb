class AzureCoreCpp < Formula
  desc "Primitives, abstractions and helpers for Azure SDK client libraries"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/core/azure-core"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-core_1.16.4.tar.gz"
  sha256 "25f8badf23c66ae82debd95e0d074d6269b276e5fa2ce5d4d3cff38fda9ab8c2"
  license "MIT"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^azure-core[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "278b20974bb5afc458a553213006ce0da4860309ab2df83c9390cf60bc8c9778"
    sha256 cellar: :any, arm64_sequoia: "b508082cfb2ea85fe887b5f8f174d790d886da721c16931cd2370b4c7243f173"
    sha256 cellar: :any, arm64_sonoma:  "7892aead1278609b42c310075f280d2d0976b302ed6a84448bf6245bf76570ac"
    sha256 cellar: :any, sonoma:        "711c420a260ecb876ea996e3cc61b1361e0f82e743bcc094526632c50be2a551"
    sha256 cellar: :any, arm64_linux:   "ce60d756b60210c4454068bfecd5429bdc2f7c22c816de5afc572b6e9341c37f"
    sha256 cellar: :any, x86_64_linux:  "4b9f90561cf7322cb06a551a5a6fb9fef2190db6afbbd57c8447a4136adb3489"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  def install
    ENV["AZURE_SDK_DISABLE_AUTO_VCPKG"] = "1"
    system "cmake", "-S", "sdk/core/azure-core", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # From https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/core/azure-core/test/ut/datetime_test.cpp
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <azure/core/datetime.hpp>

      int main() {
        auto dt1 = Azure::DateTime::Parse("20130517T00:00:00Z", Azure::DateTime::DateFormat::Rfc3339);
        auto dt2 = Azure::DateTime::Parse("Fri, 17 May 2013 00:00:00 GMT", Azure::DateTime::DateFormat::Rfc1123);
        assert(0 != dt2.time_since_epoch().count());
        assert(dt1 == dt2);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test", "-L#{lib}", "-lazure-core"
    system "./test"
  end
end
