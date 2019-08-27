class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.170.tar.gz"
  sha256 "0ee9e5c099246dba0cd6d514bd11cf1dda3a904faff530a07db34fcbe86a0108"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "80ac81f31a5dfcc3f1604a4b0cacdb41dfc52070f3627819aae540b98f5d1f32" => :mojave
    sha256 "d375b2287e9309392c92e938149e60a875c3b95ffa8b21e8d7d977e1eef1915f" => :high_sierra
    sha256 "259d9f842f4b51548b09401c01b4e145186f21e7593b43abcce8631492d2ec74" => :sierra
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
