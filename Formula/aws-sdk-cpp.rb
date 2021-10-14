class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.120",
      revision: "9ac19a89650cb5f2215d1fcfde0ff79618824009"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a4548199799a00974d9e5ad65affc99def095d2a667f540d75005af516ecf9f2"
    sha256 cellar: :any, big_sur:       "1a5d839ccaeb3e6b13f43c8c7a1dc738ea31943c6a4d4fb5b7389242a1744836"
    sha256 cellar: :any, catalina:      "fb552d7946e8ab701459c7d92bc418b178503d59cc2455191ad56514d4ce945f"
    sha256 cellar: :any, mojave:        "87eff5514bdf817372edb8af6d71c302553aeea03a32510d5af70c325242d5ac"
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
