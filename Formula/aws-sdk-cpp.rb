class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.350",
      revision: "a7de1c292661680e73f21b60fbb6597abec64de2"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "36acd7c70f79c391a61361745f2b7538d489695d6ee4fc8da5fd682ab1c8e250"
    sha256 cellar: :any,                 arm64_big_sur:  "6c954af60347dfac5a61209994f0e0616aa72664996b5d0883fc36e1d751afb8"
    sha256 cellar: :any,                 monterey:       "56808c4e37547dc68c7d709a49cc088f0ab43fa30adfcc70252bcb957f4c0d16"
    sha256 cellar: :any,                 big_sur:        "9af2ebaa7a2ff95e23bea30005834d853f7979a7b18a2a39983f7f5c0322b2ba"
    sha256 cellar: :any,                 catalina:       "36889643c101c27131519221b89ecce45a94130c4e082bb43e8f4fefff47c9f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb484f372f672867044f3e792f51911d628ee2591f26c18745c59b0524eec31"
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
