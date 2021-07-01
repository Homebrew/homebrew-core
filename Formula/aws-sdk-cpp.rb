class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
    tag:      "1.9.50",
    revision: "78ef64daf78e1c6bc95b1545ee91fbf4659d6536"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "253f402f23970c075f1d105fdd7121a8aba43e57a859c91e5217f1a7d60f5691"
    sha256 cellar: :any, big_sur:       "c83cc325a412e8f9f43329fcbac4643fb00e7826f5eaf16585dcfb45600abe9e"
    sha256 cellar: :any, catalina:      "cd0cc38544fc85111160a0fa16f4b8ec598915ccf0469898eaf26056125f7619"
    sha256 cellar: :any, mojave:        "032f0997f868c42b2b83519aab7e04a9b252ad2538ddc257cc60667cc84e31f6"
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
