class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.100.tar.gz"
  sha256 "d502d5b93eaeed574dc4af27c9af69498a0ffcd5435e961b60df1986319c8a11"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "c568ec52f94dfa073bf548a0d6eb77ba75f2a52ff93e9ed3873bdc3a00a09ba5" => :mojave
    sha256 "708f61f9dbd5d05582f93323847c1f084ee4423f60afb02c6d20134c2d9be195" => :high_sierra
    sha256 "d0ccd9ecc348bfa4eb790f3ed24ce4fa7a0f337a442cb3b353e41e09558fe0df" => :sierra
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
