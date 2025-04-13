class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.25.5.tar.gz"
  sha256 "2d19243e7ac8a7de08bfd005429a308c1db52a18e5b7b66d29a6c19f066946e3"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "956b0c9fe7993a46da3a49133a88af419e547c3d821cf2bce98e6c9e4ed6c30a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0e12409a1ba59ae6e673fc70a509c4a74cb6f76864eaef461ab919d81398f2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77730e201944e4ad0d74edc0ce6d074a9f8cb66398c4cbddedc27ecf087c0bda"
    sha256 cellar: :any_skip_relocation, sonoma:        "929cc096155ade33af92e3e59d2a8fe142630db805a9b455413380fdcc236674"
    sha256 cellar: :any_skip_relocation, ventura:       "6d289436aa1ddaf4e73c133ee11ee6ebdcaa8b041d58255f60d2276aa5b72406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4896546019f70102efca37b44eb966c5cbabaa77c72ed4b5694d650a21862fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f362d43b190473d8fe34bb58be9c6204df811bb2963cc816e6966755b8bc3d4d"
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
