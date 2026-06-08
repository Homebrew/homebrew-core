class AzureCoreCpp < Formula
  desc "Primitives, abstractions and helpers for Azure SDK client libraries"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/core/azure-core"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-core_1.16.3.tar.gz"
  sha256 "70d5d2aea5ece95148ee8b71fb302ae35a1178e58b58150a14df8866a0c54464"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^azure-core[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b95692fd239ba779332f8fef3412d8edf61b1fc21bf8b2707ae71572bddb0469"
    sha256 cellar: :any,                 arm64_sequoia: "b42033893d78e9f66d16c5a6f391a75aa34e0e2bd41c4366c0613a94e1c2acbd"
    sha256 cellar: :any,                 arm64_sonoma:  "cb3541c5f3c6b37b445fe6d47b624ec3044ac0d9ba34d900efcc77a7c40c1436"
    sha256 cellar: :any,                 sonoma:        "b1c37a01b888d9123d9efca761cb7d5dbe2dfcb65d5f258b7a22d3a683b4abaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3453310ffdb1f66b52201fcf827ed7e055c6da3ece54623c976b065200cc009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4fbc2a6589ad18fd77001b83f2284f0a7c84d0f1cffb62dd988a6ce6322313b"
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
