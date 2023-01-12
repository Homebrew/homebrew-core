class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.10.50",
      revision: "341fa41cf8a0a3ed052f7dc872223ebb4a6c98da"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b2fc7a6fbae3579806b301cf3c4fbde299cad5d0312f99ced7752d67f92810a3"
    sha256 cellar: :any,                 arm64_monterey: "aa51f1b7994acc9ed19ee33ffe48475e738720307f0b7847c19f5cdd88cb8b17"
    sha256 cellar: :any,                 arm64_big_sur:  "6a232e3df1f2a8d4c8aa574592b1269dcf947de2a1082b17206e4b5f79f13f30"
    sha256 cellar: :any,                 ventura:        "83fc938dfb370e8864241c3cbbecaf9888b7a6265a640268e1322caeb91784a6"
    sha256 cellar: :any,                 monterey:       "da88956dce7bcda7f1205cf4d600bf4570c9019b147d34ef731418a172bfb199"
    sha256 cellar: :any,                 big_sur:        "90482986c0c380f6b62988748d9f525dceb641b4c952d83843735308a742c834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36bf8503d3ef28694f4ee41459541a555b750edac3f031cfe7cae10acf5adb61"
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
