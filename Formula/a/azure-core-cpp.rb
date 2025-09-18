class AzureCoreCpp < Formula
  desc "Primitives, abstractions and helpers for Azure SDK client libraries"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/core/azure-core"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-core_1.16.1.tar.gz"
  sha256 "4d2a85be0a5b7ced9a75cb89434fa6c0712784fb3dfd5d378514197bf9d21e96"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-core[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "147b229f3cd5c72c2b6ff353dbd34a0677a5a140ab3d0352d51718a24fd7173e"
    sha256 cellar: :any,                 arm64_sequoia: "ba3db1c8658ac6e079e8ce49ff6100da42895193000081b2db75b5d5d39e5aee"
    sha256 cellar: :any,                 arm64_sonoma:  "32853f153fba753256d26039b0ca9da4a39d1c22b94a5ee94e5af03a599747ac"
    sha256 cellar: :any,                 arm64_ventura: "4966615792bec9650801744bccbe9d872d26b6a7974e6da7372fe61939d0fc4d"
    sha256 cellar: :any,                 sonoma:        "b515c0397f389c49a1e5c585e036ff64fcf1cc319ec2f790c7c1a3e5c9214925"
    sha256 cellar: :any,                 ventura:       "1475ad75fc67f4b11e2472a6ff93a56c8cd3954061b6ce68971fa0b9c81cb5ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03e8711bd015d54c60d0c4f7d502ab075ebe4bd3a84a5bf817303449818bf5a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd63088a70b504ace021c6fedc8b0382d5455e5152315beb897f3b335fd973c4"
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
