class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.26.2.tar.gz"
  sha256 "e4dd9c78c17efa4ab79290d6a1c66c686208382ae1a689554d18d640761d0316"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83b8937c42a6fd65c510e63fa33ac1d4b45108f5d91f3cf40abe79ae971144e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57541a42af07f51f50e9db9cf4c9a75def6f3e0f1e8a6f743d3e8049c5be8954"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b7f797b318177f72038f448f61ff1b677c8831fa736a0e848d0e66eb1d3dd77"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8ad4a9ec70659bd1376d55378a6547e63ce6c0fa315aabea14c92c585a04d30"
    sha256 cellar: :any_skip_relocation, ventura:       "162a3879313c8f428eeecc7cfe8464ebe78b34dbe51d5bf1a525a9b01f620a65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ead64ded5eb5e703d68806f5b194d37793a0416409038647f601ac641e4eda25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8cdf21327d4dabc5983844bba3c2be6e3d3f02afc90499ec45908d0cb4ab2d4"
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
