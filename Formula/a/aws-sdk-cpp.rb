class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.145",
      revision: "d87ca7241f36ce4c7015eaf06b77f586049b11a6"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f5387e93379c2d3dab6ee652ef480dc21cec4d057469268b6500b77e9666cd65"
    sha256 cellar: :any,                 arm64_monterey: "4b0a6b9db0c6d0f7c7cdb7d637e8fcdb662a8f088340d3ca73228193b2b95d07"
    sha256 cellar: :any,                 arm64_big_sur:  "f6a283d54ae02558a66d32f14f8be708c30b171aac38c538b31590e731050861"
    sha256 cellar: :any,                 ventura:        "a9a4f138859778c01f4c66c51ce1563915f1a045ccf214db4be4fde5cf66ad35"
    sha256 cellar: :any,                 monterey:       "27bf62dd03c2352d6c5a6f55807d7680abaf6706d09d083e112666ff2428c759"
    sha256 cellar: :any,                 big_sur:        "840bd3551aa9577be4ac3e8d88a4a2282ec499113691a17dbdeefbdabda8218f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622811aa29136e6049295935b9ea8678b66ca5a56a873cecda68e105b9f37c06"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end
