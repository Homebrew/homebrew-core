class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.26.3.tar.gz"
  sha256 "435bfd99a8d9a7b7b2b4fde33132d7aea125e612decc9138bff6895ed0144e95"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "778db4bcd075d034bfb21ada0baedeef713a0a702f7c2e38308bab5443eaabd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c4dada7487facbca9422319c2b14ad67d09a600a4f7bbf2ba26d50a2025f895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17ebdc3b13a6647f2d9493125a04f0f16caf67bc5b50e801c70be20fddb55d52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffbc0035e634120ef59964b3330caf70c0556d4fa91197c1059f2bbf8ea1dea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "63e7f0d2fbe1986331239e5f6d690202b2d788d9e04a01a31c80e7bdc99a5bf2"
    sha256 cellar: :any_skip_relocation, ventura:       "abcef156a4ca5023e07784e8d0f34fc36f87baf687d4ef3f362e2b7fd143bb35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3de370c06e120d8bfb4fa1e3b174bea2626c2ee3854a6116f340c92c9566b5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4568bd0746da1285215b21f6e7631b5145dfa698d1f4a1b5b9f2188d0921088e"
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
