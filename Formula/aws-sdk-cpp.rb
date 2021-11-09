class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.140",
      revision: "e0e4ce21a6d6229b3193a4216720ead5f085a4a3"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "de3feeeaf6fd93e0784208ff0991a18f0a23b2ec0c50aa4f0e1717341b74efa8"
    sha256 cellar: :any, arm64_big_sur:  "cf430ec4d21e6463e2c0cedd0fa15662a7313cc47224fb1a4f95e4f4372b6ef5"
    sha256 cellar: :any, monterey:       "b74d6cac8e57c845f5691e7f4a80718653c56cdff5e001ee4fd7aa7ac216f535"
    sha256 cellar: :any, big_sur:        "6d75785c07f6d6204308d354f642d7ec00fa631a4d471b84c2ba431d7641595c"
    sha256 cellar: :any, catalina:       "2d8efe45b2b275f554029ea06b203bbfcad2129e85eb8b955c6b96cd70a5d399"
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
