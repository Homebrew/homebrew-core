class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.175",
      revision: "9904f00193b161ebd67d3e06551778c97ff6ade8"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "314c190ccfa22eb658aff18eb51db0e9b5f8ea3e137b8bfb0cc2742b3231948f"
    sha256 cellar: :any,                 arm64_ventura:  "4904e55ad8c54ef4502da7cf4d276ec22264f43e5e969518ac2a2e18c01786ce"
    sha256 cellar: :any,                 arm64_monterey: "4838bede12cbf878e720ed324ff7a4c11cb9cca3b661bb9010ddd8106c9c34d4"
    sha256 cellar: :any,                 sonoma:         "b52d13554e91c6f6f43342cde2ce00ec45cfc58e4d16896b7d79854e30fe6cc4"
    sha256 cellar: :any,                 ventura:        "0e569e5a81a17d925f95785323e627fed9e8989aeaa66a6350f9248cd24f6a4e"
    sha256 cellar: :any,                 monterey:       "0ef6a4946c2b1d0ed75afb8797492e7861c8df5b6e89dc19b959810dd4ab504d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb0363d7a325b25204cc2c21a021d09f12953f4d0ab91220db2f330f96b9ef0"
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
