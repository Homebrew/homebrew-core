class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.100",
      revision: "0175cb2dd1dfdae3fd5f49a984db03802786746d"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2c6164c34091b9f9c1fbaf50ab655768f9b0278e911a0c23c5346ff19ad0d475"
    sha256 cellar: :any,                 arm64_monterey: "b40fa2ce8064dfee204b6a87928432e1ecbe9c5f7ee71a4080257167664a4540"
    sha256 cellar: :any,                 arm64_big_sur:  "863045de34a97d037962f94bef2f9a8eb8a8262c9bc2cd587f31956f32730ae7"
    sha256 cellar: :any,                 ventura:        "e6dc02fabf37eacd0cccdf8f3b8af5e54d0c1cdaf1a3477e5e4524686d8ffd92"
    sha256 cellar: :any,                 monterey:       "97c44567544df6eaa7cc1a170b745e2b1b64a61661ced5de7325c8761bcafe28"
    sha256 cellar: :any,                 big_sur:        "69e4c75678e18c07b1588d173d067d03935e0700e97ee69f152eb714fd6ab88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef3de3bd03b7f17797e1dbf71285b212d5a5fe70591b2df3c413cc4a258a9510"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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
