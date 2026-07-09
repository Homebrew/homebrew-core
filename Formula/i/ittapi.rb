class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.28.1.tar.gz"
  sha256 "240bed5de766de092c7ae3fe2f0e18aa3f5d203759d990902819aa6d269ba294"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2acb843ecfd501a1c8b68864eee04933b914a922f22e16c7b46d8478f92b40de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04d41a18af3a8f8c3e752dedcb984bc749d908bc8450f807ec5ee7f2efea74ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad0609f0a8124c1d62cd025d2f3b56491a9776185bc01fd4a1ecc490d2fce9c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f55225992e76a3215cf12d92ccea6d66639b5730b90574131d441605b913d57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24a0a8babf2f353e022bc12e196f03f9743f9013fd5e65c1fdc7fc1b26bb004f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddcda8b7f69144afef17df517cdd6eb645d7ad948103bdc85c57ca7663826b9b"
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
