class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.320",
      revision: "9a3e6e8e31636ce341a43355d58a2717033f2668"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "81b56d05e77548564afa0e93603379ce26cd64acb5e9e8d615d5ab9744288086"
    sha256 cellar: :any,                 arm64_big_sur:  "045caa0074c04b231ef27e27e42ed8206f9510311dbf977e36bdf09b45a49e7b"
    sha256 cellar: :any,                 monterey:       "fcdbef5a994ef4994749b508aab463dfe807ca713f64bf96dee61feb4a4bf5a8"
    sha256 cellar: :any,                 big_sur:        "7047d80b6b8dbb0e84839b0544ef223cf005ac515a617583b8b6b4974d8b2aee"
    sha256 cellar: :any,                 catalina:       "f61d38da9be020a7d6f535017060dcffba7e94b62d936972acbfe79adbfd7432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf8d8b696bd723ee55dca5829fe8278eed86ed1ed059826cc30c0ba492276df"
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
