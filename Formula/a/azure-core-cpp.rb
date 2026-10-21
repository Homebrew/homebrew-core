class AzureCoreCpp < Formula
  desc "Primitives, abstractions and helpers for Azure SDK client libraries"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/core/azure-core"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-core_1.16.4.tar.gz"
  sha256 "25f8badf23c66ae82debd95e0d074d6269b276e5fa2ce5d4d3cff38fda9ab8c2"
  license "MIT"
  revision 1
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^azure-core[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a13c120f883413abcb8c0bc04b2d9030c27d49496f187cbcf9f0c8ad188fc1d3"
    sha256 cellar: :any, arm64_tahoe:       "20326047f180a75904f9bd54283db5e8066c9f7fbb4ef1442b0524a3a4138ce6"
    sha256 cellar: :any, arm64_sequoia:     "10ba6183849f3a316c696f1d7a24e41929fd55b97d7e794597ec9a6f098ef98c"
    sha256 cellar: :any, arm64_linux:       "f6e1df55376d7dbe2be1bac31c2499a21ce69c8e95c93fc15f120eaa4890b702"
    sha256 cellar: :any, x86_64_linux:      "4c62f87eade25286ee008be255ee4a9ccd9b75da3b18fa19cac725c52823fd86"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  uses_from_macos "curl"

  # Fix Linux build with OpenSSL 4.0 where X509 name getters return const
  patch do
    url "https://github.com/Azure/azure-sdk-for-cpp/commit/df5f5783fbe525a06b0146fbeea6515d25376cb2.patch?full_index=1"
    sha256 "f351cc0bcc32523bededc4e1e3099c07ef582a8c4234cbf8e8b60bb4f714920a"
    type :unofficial
    resolves "https://github.com/Azure/azure-sdk-for-cpp/pull/7456"
  end

  deny_network_access!

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
