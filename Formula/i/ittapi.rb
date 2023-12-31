class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.24.5.tar.gz"
  sha256 "2a02c7018601ea193fa7b822b52219c85da5131f1b8ea3d89f65604ef68e2fcd"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eab555aa33a171691733004b2d8d5c3503ec20a0b8f32423cec42f308de3d1bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86ded00a5f806b50b485faa1b0d14b72f5c9d1941ccd87a9509ed42c78a69f97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88f753017e618890e1389069c390899b634bd0ca6eabdce1d1b21e09959265b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "501814b063593e4037c693b495808cc52761d0949cde751e0d4630ba67bd7397"
    sha256 cellar: :any_skip_relocation, ventura:        "80f639ca308fa26cacf46eaddd4b0309bc299141a18a78d23b8655cf1b385a00"
    sha256 cellar: :any_skip_relocation, monterey:       "66930463145b54ad0e10737eb8897a1922537c2c82ba462a29fd7b23c5c5c43d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00af8eb8df01f69ff6af4dddcc6779829726510c357f2773a18d8584d3a9406"
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
