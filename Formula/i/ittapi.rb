class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.24.6.tar.gz"
  sha256 "4e6cb42b6bd9e699e3dfbaf678e572f4292127dfee3312744137ac567064a26f"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d21f77b26d707f05747a8a01b74b86ff138c4d6ec79a9ca0338b8e961b698ccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8bff4141b9a5765dc86e406cf301d670bc99af0701a8ad0b82621c002ebb567"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b9ab35e23524ae02d9bea684d6b88786ec76c9e4a0e2d325e9ac12a742b4171"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6db3164e0676e96dc6cda2ba2d7e133c53831e53f57932d3bc3ec25ee30e511"
    sha256 cellar: :any_skip_relocation, ventura:        "6b89b05910dab67abaf4b20f506a0353dfbd5210fe48db9e746fd42ba2b5c1e6"
    sha256 cellar: :any_skip_relocation, monterey:       "04e0759d6ff6a1080b806845ad3e7c4961e2e1af58b3f366eb60f9009c022af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a442aeaef8bbcc295a9975c21f526efd5fc5be45e2a3487b0f35c55b7a19e5"
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
