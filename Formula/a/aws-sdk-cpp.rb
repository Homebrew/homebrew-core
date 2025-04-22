class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.540.tar.gz"
  sha256 "36c5db6f860368f37887aa2d269e4679ec79e858028818e3d4557540c24e0e0d"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_sequoia: "78e421fb2922689288bd14ce89585bf9c9f10b5dbfbbf8e281b953b913a838ef"
    sha256                               arm64_sonoma:  "9a9540decfd23c19a4f756062fc0b387774c9318093ae08cdcb633097f146809"
    sha256                               arm64_ventura: "30d4a1166c2a0ef83674eaa277a842baa96229d9a2beeac9facc6576d2a585be"
    sha256 cellar: :any,                 sonoma:        "3ffe71c3a41aebc111e9eb408e461abb1fb0543f4ef6f85915e7f91073832031"
    sha256 cellar: :any,                 ventura:       "1a42ad3201eb761ad00dace121158ae579801b73c9cdee93abdc5b540b89c9cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14a165aee92bc90666e758a1c3f4c8698b48fddc5946c579eee5b031a750b2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbab0f432a2a154849a27a12e7665ed1dee17a6d987077db05a692cabf6a4ac7"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-s3"
  depends_on "aws-crt-cpp"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    linker_flags = ["-Wl,-rpath,#{rpath}"]
    # Avoid overlinking to aws-c-* indirect dependencies
    linker_flags << "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %W[
      -DBUILD_DEPS=OFF
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake/aws-c-common/modules
      -DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}
      -DENABLE_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end
