class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.28.2.tar.gz"
  sha256 "04d9f7e8f7f217b732f5fa2eb5a7e7e8419525afebe5ba086430e489f8261280"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae68339c7a344258a3818c84f69c183efc2dab708689045c2ffa7c8e70ad231f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fe2adc30469ad09392a7f276d48955a5109973e4e5a362ee894bf00d644f135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7e820d96166e43b3caebbd82a9109d50eb0ee0023a62c1df1ecba0b8e37985f"
    sha256 cellar: :any_skip_relocation, sonoma:        "49354bf1afdd7a6714f9dfc9c4ec6d79ab154e2f103c03a4203288b80a3ccc1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86863c5141a12246e9a5e4cdbfc0c7afc11969d53da6fdbddbd6bef66596dee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f852bea0f9947fd50fc59ccd49105c5165c26193f80ea83027aff0a4ed79fafb"
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
