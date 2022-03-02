class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.190",
      revision: "58e1b647562acf706b05f926d59d656f704d9002"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d91e35797dae2338aaf3766d94e46ff0da5712ad87d3726b7ea0f17ee9c6a38"
    sha256 cellar: :any,                 arm64_big_sur:  "eb90ac16e8197d55f656c3e4dcaa4892872befb2c004b3137163333181d298f4"
    sha256 cellar: :any,                 monterey:       "e719740b6fb8d2e0601061b3605894ce1fb0da862974539145d9c8eaf32bcb86"
    sha256 cellar: :any,                 big_sur:        "7ee4975b27cd730e8101415e1776b81acbcdba6a6d87d067fed8e932ad28345f"
    sha256 cellar: :any,                 catalina:       "220b22e76e4adda3b44848f8b3580777669cfdd2baf4ea7fea9088fd273be945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2494d9a986f84ecdd2de487195c6f63a9e9644d808a33a26fe16c9e4d2a77742"
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
