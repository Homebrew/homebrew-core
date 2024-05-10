class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.24.7.tar.gz"
  sha256 "2ff56c5c3f144b92e34af9bee451115f6076c9070ec92d361c3c07de8ff42649"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59894b39e7e95e9d1050b7468458fdfee44bce0364dd80ee17288e51e680c2e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff77f4b1b8f9f423d8daebf61db79ed422175ec3b9083ef90b481d059326fc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4c0a0516ccd7635a5cbd17bd2ad24395aa8b09145f2ccd98b0f3f11c7f7dda5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1acd2d4c359b0fa492c5f9f59e21d1f0a52159534b38aac9a5d36da35f3da41f"
    sha256 cellar: :any_skip_relocation, ventura:        "5fcb30d829c76575b8614b8f7939db226af6714a67bb985db791e20f0d497e74"
    sha256 cellar: :any_skip_relocation, monterey:       "be59f2e68de28d1e8349d76356ec794c5f816bfc2d856ef344a8ed01a089bfb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf089ae6f3c440cf013b2083391303a086b4001043f9954ddd9abc384ecbce2"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ittnotify.h>

      __itt_domain* domain = __itt_domain_create("Example.Domain.Global");
      __itt_string_handle* handle_main = __itt_string_handle_create("main");

      int main()
      {
        __itt_task_begin(domain, __itt_null, __itt_null, handle_main);
        __itt_task_end(domain);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-L#{lib}", "-littnotify"
    system "./test"
  end
end
