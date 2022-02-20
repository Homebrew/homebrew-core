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
    sha256 cellar: :any,                 arm64_monterey: "0701769618d2636a73f5144d363c167c8ee1bafb9807dd7eb55b48a2abda78e4"
    sha256 cellar: :any,                 arm64_big_sur:  "dc9d7d2febd99af12cd0a0451cdcbd133ad6ac2d8285e93400711fac2da78a68"
    sha256 cellar: :any,                 monterey:       "19a0f5b9765086d91eff8cecf3535ee9cf09c21bc947c196e77c527606224210"
    sha256 cellar: :any,                 big_sur:        "bc6d2f66f7c9fc4f8e21ad81e198e5981f20f7aa226dc1e50a3bf828f8599409"
    sha256 cellar: :any,                 catalina:       "c4326355e8c4a2ad63a4ac074c32f9cb956369e7223e1d6b3f07281715997427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e53790788bb92d9d6638c495063e051fb0243fbe0efd6be0a33cf96c9c8e392f"
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
