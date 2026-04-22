class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.26.8.tar.gz"
  sha256 "0b8b387b02b3ea1111ecb6dcb2295558dccb18dcbb0192d401c9db6a6715b28c"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69450b46fa89379d1d5d0ae7f0467e106eed81cea2e6572306a08a0d52137f48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b98a0527259bc9d1fb7b0fd478a2d7da9ffcaae6a052a91c77034876ebacc050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97263f7c7e1a5bea0a860b0a46a43f52749dcd003e0e4c653c233879df37705c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a309ccda4158228e2a5340467e18898d623d664edcffec510c21b5ecc749fc07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048c903462d0e94f367100801c84dd00209a7f8b7147ec15eb0f0979dc635254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4850ca643f2dbe8070dec43da3da2d7647a47b9166a22e00a41a01ab2246fde1"
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
