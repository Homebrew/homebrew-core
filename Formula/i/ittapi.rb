class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.28.4.tar.gz"
  sha256 "70572732cdf41c2625fe18c8f3d4f71533b114cb6889fba18495422973560ca3"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e228bd1ab4294e46024d37c3e92f72380fb3064eecde4e594d31c6b53e005f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2883d94a5feb406111ea3a69a67ec46165ce2ca3665ce1f1a0dd271af284c522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfcbbb0fdcd5528a0baced38a097f8100bc37c18a2f91c348d510de8b32336b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c4c9865a55afa28d7a18e6de38c96f5cb7facbd428b9f71042c533cf6b4b4369"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6daff97acb8174a65ed544d85aaad4afea6760ea3089868fb479fd2585973618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4f77c9fef67067f195a0657996445fd04e54b5a00637e361e2dc27c2230fae0f"
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
