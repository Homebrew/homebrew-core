class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.28.0.tar.gz"
  sha256 "39d47cf33bfc4101dcca61c00f9ace9a0ee50ccd98bb7905291f2f0679f5b6df"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcad89019e286e0aac63925e188232b163ac232fc877abb2c764298d47618f28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d59a6e367644f3d77e0c8bc937e76997df44e8db6ae0d60f45ab7fc2c7582b98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad33dfc86c5379f61e5c4915e64a34e8185ee37948fcf3d840051b142c0b7420"
    sha256 cellar: :any_skip_relocation, sonoma:        "021042895ee9fec901c8dbf87882c70b658f4af6b0059bb28e1e0acf44bad038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45f275711cc239c93225bb31e910998889196fa03b18c64b508bf72673c0a69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bb71ae681f23d26d5bff9896b26065808bb6086934c8cb193ec0ab41793fb0b"
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
