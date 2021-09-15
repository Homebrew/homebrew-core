class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.100",
      revision: "27ce81a0398e16cc6b659d5e0e7c5bf2f768ea55"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fa2a52b6c766d05c2646dd57eeb20cca50ca17f77368d5ca194c58ffde88bf5e"
    sha256 cellar: :any, big_sur:       "ceaea256f195677b99359687b3c29d24757aba7180439ae981693f6a978802e4"
    sha256 cellar: :any, catalina:      "2ff81ba7bed470af2a020b7f2e58b706ac073cf44488a538fba9982f90da504c"
    sha256 cellar: :any, mojave:        "44c122fc533250dc1c6764e65b1e02c4be136066506b59c06a6671f54659abe2"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
