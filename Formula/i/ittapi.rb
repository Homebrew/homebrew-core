class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.26.1.tar.gz"
  sha256 "e070b01293cd9ebaed8e5dd1dd0a662735637b1d144bbdcb6ba18fd90683accf"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5424508c20204936d2fad669378ac204bc082015502cf15ed36550ba6f64c76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad8d7db2bdfa50d5c4c298b2a570599bda56b71fcc7d08ac36cf7de96c6ff64f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "211f381413eef7fdbf6843fecdf4160dd8748dc1d652fae6dcd0c3d096825eb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cc017753e4c3c83d108cfd2dd9e0d84f8d0c46ecbd53958cca0fb8f9154dab8"
    sha256 cellar: :any_skip_relocation, ventura:       "fa2e9c2e80eb616452e93de954e8b04afcfdb36cb9129f32e64b18a9a538e4d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b35467fb43af71a19ab43bdf8cc72dff27ec833c4bb1155ae5d22f46aeb3d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea5b67f7f9f0d42188564fda3e430f4fd33ccecfb933e404e7f69ed3f12545a5"
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
