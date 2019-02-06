class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.40.tar.gz"
  sha256 "dbec87e8a030d4cb8f113bb128a094afb6a7c3ef4e70e9f599127d6cbe52bd7d"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "bd16b85169247bb8c0f33fa1dde30adb44e4c1219f821748f753a5ddde980a45" => :mojave
    sha256 "27ece6fdc09e457f5a31701381030bdc487536031e2129ec451b42a859506daf" => :high_sierra
    sha256 "c87afbf3862b3f9b849c7db92e68e03a14deacdcd0eeb6d207d2daca7cb1d3be" => :sierra
  end

  depends_on "cmake" => :build

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
