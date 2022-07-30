class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.310",
      revision: "88e93f2aa2702d130519e88e0bfff1b405c5f711"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "75b03e2f17881722d876516e8e03e793c2c55795203e26a13390e3a22af50b21"
    sha256 cellar: :any,                 arm64_big_sur:  "6cbccb18c7300c98c9f72084e3a483064f1c1e4bacf43d92ca4e80159df759f9"
    sha256 cellar: :any,                 monterey:       "f37683ae377a0f1b20845af721e98b1d38cdf5e5e6bd84cdd2d2ac978526e704"
    sha256 cellar: :any,                 big_sur:        "a1d6cce4d44db4cf086342f5597c0dae1099186a08ec019cf36070ac34461dad"
    sha256 cellar: :any,                 catalina:       "206681242bd90b14998335f0e5fe6a501bb9dbdca5690f07073e469b889d2013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2afb18c8813ea403e8db9814b5135cd2a4518d83b83f42e973a67ad43f5bc501"
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
