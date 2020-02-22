class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.280.tar.gz"
  sha256 "f15a9ddea3cc223614e41aaa62a8620e8df65de5bcb21dedd1ebeeba31b04c12"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "86fdc90b98e37fd497a70da96d5691e71b85907267ee3786d7703f8e4ffedced" => :catalina
    sha256 "153ae38c0c6fbda419e42988e9bd8328f076926ff92057a7f61ebba37c37ee50" => :mojave
    sha256 "178d8aca2057769087c18aecc83a239d530c0e8a92b29658f33eff5b699b3567" => :high_sierra
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  def install
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
