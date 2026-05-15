class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.27.0.tar.gz"
  sha256 "a2dc3f09d9f22b1b5414c6923fb47ec238160f2bf730a830959af9b072ef0fc5"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dd7bd8fa76c368fd9e52ee8c272695747a0147a57824fb7319f7992784517e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b32def9f68e9e5aa867b5c7d6a499f5005b45c5b1d20736af65defe925c872f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b24242972a142aff693f9b3413f5b5f77ad7210f19ae98cf6b00235c62243c05"
    sha256 cellar: :any_skip_relocation, sonoma:        "d49d0371e4cb794c18b9311194fb7670a583232dd6e35418b0929e73640e38d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a3eea453a1a4b8379d88ba065f87d8c3d26ed22b19c2eb8cc2828aa544dbbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a2946b0b087d168abcc89bc1d3d42ca698b2c11d5dfb3164fa86d504f160f4"
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
