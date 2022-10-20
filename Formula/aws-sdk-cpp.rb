class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.360",
      revision: "a6da713fe5992964fe703ba183778926ad809b77"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b7a7bc8b2c30bd69fba64595c079ffb23c251b4ba52ba1e941773221bbd56965"
    sha256 cellar: :any,                 arm64_big_sur:  "1188f6c0fa5684abf0f2c0dd446b3634bd72cd947e1181cbd130b84b00d90b78"
    sha256 cellar: :any,                 monterey:       "3ac5400f7f4f6ac14f45358b6d2ce526d8777552872005507882bc8231f4fede"
    sha256 cellar: :any,                 big_sur:        "aee9ead5101c87af05d2c69a395c5a5fa24044f44b2656041b5b8409de6c7c6e"
    sha256 cellar: :any,                 catalina:       "50c48821e92a79d08463ca205e03efb36d9a82c307640576e0b9c1765994637a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7fab01d7b32f59f7f641db3beaa2269bc2437f065d9dc6780721ecf2e41373f"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

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
