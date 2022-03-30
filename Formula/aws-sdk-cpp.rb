class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.220",
      revision: "a72b841c91bd421fbb6deb516400b51c06bc596c"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "88769ab28f8c093318a879939bf6e14fa26644656e404309ad1aaa7bd0dc8095"
    sha256 cellar: :any,                 arm64_big_sur:  "b67c3ad3b64cb0cd3d4edbd9e300849f40d2d134f2b21ed8441e6417cc09a5e6"
    sha256 cellar: :any,                 monterey:       "c82d51ef62de5bd935b91aa0afdbc17291777572bd2b0630e90e623fa6297136"
    sha256 cellar: :any,                 big_sur:        "7d127cf5f115d1d3a313190912e8149fe66e7a1976046803e485a4b8b083a2df"
    sha256 cellar: :any,                 catalina:       "20bf4e6c9df9715115aaaa3840aa738201f30577bf7cdb26525f53fa6756c9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a1ff089571402398c316cb709007afe5f56784ef126941797ee24d1cf40aaf"
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
