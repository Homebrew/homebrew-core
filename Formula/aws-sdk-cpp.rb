class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.280",
      revision: "c396dfb4191cb46d3e08972a8eaf0b786975f206"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eb7ac7e8a7f22386e3fe52170bf762f17892d653ffb9ae017134e7aa4dbe248f"
    sha256 cellar: :any,                 arm64_big_sur:  "1d16866878ef5230dcaf306a159061f0803f71f747e673937dc2cebf752dbac4"
    sha256 cellar: :any,                 monterey:       "3d776fc949473d8aefa9d71dd0758309df02bd34e63b9b0a3c8cbdb45b75f158"
    sha256 cellar: :any,                 big_sur:        "7e69b3b1537822137f65c9a62313f9eec576ced8e17b3d0f26f7871f2bc819c7"
    sha256 cellar: :any,                 catalina:       "515f38b5e8f92437b49ef4d71dac1eab01b2e15b95d73be1e374c3a3720d9e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee5e299f8fae68803e29b0b4e4cfcd987000e7d0f948e22e597b378532e9313d"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    mkdir "build" do
      args = %w[
        -DENABLE_TESTING=OFF
      ]
      system "cmake", "..", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
