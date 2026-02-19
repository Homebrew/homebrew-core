class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.26.7.tar.gz"
  sha256 "29aa0dd50cdf0f0a0a21563eafc5b7ce79052c19594a64017a51f09304a4a39f"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d05101c17697633c91b8cf06058aac95ae5e2e1947f9f3dbc68b9a84db53ccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a5993bf31e09437b413c602fcdac7ec1fc783248b2121d9fbf5766a87c3022c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fa365b006c87ce4fc95ca3dcc2cd556ba1a269954495322419d4e6bd9fdf7e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac55f764a363deb44bf6c2fb5efff6014d3fac293ac285cc8b6e175cfb3b68b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a6a36c1506023abbd92c88c07da92313074f6976636931a6483db496833ca4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34fc8bac72d908cd322d8e876c1a18221df43034af87d47915d5156845ae4cb2"
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
