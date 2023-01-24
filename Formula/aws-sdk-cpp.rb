class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.0",
      revision: "276ee83080fcc521d41d456dbbe61d49392ddf77"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f40729ceb57669114ea93124971a7952950aa647b07843b6273a06f59b315ec3"
    sha256 cellar: :any,                 arm64_monterey: "2f1f276bbe120d4457eb01637e259f896de13663ad5ddbce9bd6e0da253bbf46"
    sha256 cellar: :any,                 arm64_big_sur:  "74066af3a34e11802a158e21bcad001547ed46cd89c6599d4e6f7be8b69a4510"
    sha256 cellar: :any,                 ventura:        "a991d0f1ed81ace8780d13c7b50084b81daefd89437c25b1c294b7f52e5c11e1"
    sha256 cellar: :any,                 monterey:       "faddefb9ccabf5b508b8e607d80bb761d3b3a501a0bfdb5a89c1e7e4be53ada1"
    sha256 cellar: :any,                 big_sur:        "b78bdcab6525deba82b4547de3adbef8720daab5a95e28e17ed338363b8d73d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bd402ea73cf688a06bcfb0e0fea0905704fdba0d394c92706097f556628d520"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    # Work around build failure with curl >= 7.87.0.
    # TODO: Remove when upstream PR is merged and in release
    # PR ref: https://github.com/aws/aws-sdk-cpp/pull/2265
    ENV.append_to_cflags "-Wno-deprecated-declarations" unless OS.mac?

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
