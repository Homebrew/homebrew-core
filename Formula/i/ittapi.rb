class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.26.4.tar.gz"
  sha256 "22e62bc1e0bae9ca001d6ae7447d26b7bcfe5d955724d74e6bd1e3e2102b48b1"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14782645c6584ecd32e7fa0848bb9d40f1fc1f9c50b2fb46ecbcbd11aae35de1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f1b9e28613571cbe742267f366e94f66ddd0419c57e8abb5d84331cec96d84d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d2c63e4b4657c66dfaf3213ad45e00341edee701b865d5b13d1bc20a46a19c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f31988d5b8bfa029beaee55495387cfb22f05c8594d851d9431d8be2096614c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c71f0b0463de007af47c5223c451c171bfbc0bdfeab0d1d63c45295702f82be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f5ea8640635b99b3e88bafb558d3f78dcd41e9551962fe97b4993343a591d9a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ittnotify.h>

      __itt_domain* domain = __itt_domain_create("Example.Domain.Global");
      __itt_string_handle* handle_main = __itt_string_handle_create("main");

      int main()
      {
        __itt_task_begin(domain, __itt_null, __itt_null, handle_main);
        __itt_task_end(domain);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-L#{lib}", "-littnotify"
    system "./test"
  end
end
