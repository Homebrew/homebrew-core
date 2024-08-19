class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.25.2.tar.gz"
  sha256 "1d76613b29f4b7063dbb2b54e9ef902e36924c5dd016fee1d7b392b3d4ee66c2"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "802379147eb5f97536842696bc9e309ee54bfc5c344a75e1ea5c75002c7f6998"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "577ce55aea409a164e25d648cd994f9bffa620cebc7b88bd7a5ac0df19c6fe17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "299a88d2cf8ee1adf98dfdcbb28b47f32deca279fae7050ce0c200866a745dbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e19c40ceaa898c3c4b328d235579cd5ae62823f819d910d0745a757b907ec3a6"
    sha256 cellar: :any_skip_relocation, ventura:        "43e8ade45b38df4774a100a31e7501f5a4dae9f7f8344c1fae6ba2a3e7a8e38b"
    sha256 cellar: :any_skip_relocation, monterey:       "32ff6ff25098e70f42fb1d6742e0cff9108f9185aebdccefa738a028836027b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e1ae059de028aaad0dfbc8e41aefd460ef5684fccb9cd6b68428f21a767f62b"
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
