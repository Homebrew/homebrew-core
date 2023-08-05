class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.135",
      revision: "b449fada8fa4a45158a9fea802a49b072bd124e4"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc1296892caa0b8e2463f36448e224e5b2ea9a27ec26e1bf05a39a2252186f9c"
    sha256 cellar: :any,                 arm64_monterey: "42eccdf9deb68924140962efb9a4e5cbb34e0bc979244a354bda1938c42d74a3"
    sha256 cellar: :any,                 arm64_big_sur:  "00d1e2088350fcd97315867ea8fba5b34c8d6777eb279741f235738096760d86"
    sha256 cellar: :any,                 ventura:        "f0fabf667b2fe27b55953379985de45e6724e6f12fe07adc07d36341c8d68849"
    sha256 cellar: :any,                 monterey:       "013976df778ca58a22eb52676fc7c7f927648db0d701524bc03709500f64e7b8"
    sha256 cellar: :any,                 big_sur:        "500f76daf538a01940e48b9d03f733d4237c8476afcc3dfce43233428fccb12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27997d3f81b9f7d2d82ca90a7385605cef57849b4cabb6c8b8e36ae96aa16e94"
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
