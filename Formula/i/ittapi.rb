class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.25.4.tar.gz"
  sha256 "e32c760e936add2353e7e4268c560acb230dd1fdf2e2abb1c7d8e8409ca1d121"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32a49c41057cc92264c320ad96226cdadccd906bec15965a619660729bdae75d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58b16cfbadacd597225d4e3ed8376635219a881e34de961fcb589d58d86ae6fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7f4c0f155a0e5b95afb6bf7301f2a619001b87ba1a77f64f5316caf33bcf09f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4db3d96e18424c2a43e2e647dc4e330c137ea8640b60a974707652d25d488a8"
    sha256 cellar: :any_skip_relocation, ventura:       "4968ac8ca683221e4d0ecea36695013c3950040e76547dd9d647c6043a6a728a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad6b4a0761fbdefd860818f4bca1ee43834a1ce822d148bf893324f2c3297f8c"
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
