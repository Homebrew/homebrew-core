class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.24.8.tar.gz"
  sha256 "4e57ece3286f3b902d17b1247710f0f6f9a370cc07d5e67631d3656ffac28d81"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba0e23a24ce2905d031f7112002c8a4d0594ec52fa556b94a673aa1d75236a70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71571a891c57e9069f458a627ea87a5b2314e1e5a0b19cc5ee652c9e0c258ce2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c817bbd04063221824487338807cdedd5281823ebf39eaf165bfb0be981634a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6940c43e86a8988867dcb80508775e9137c548b335caf7b95d31f60ebb86cb6"
    sha256 cellar: :any_skip_relocation, ventura:        "25c613adbcd9de86db0050aba1fffff8670dbde9ca9a07bec566b90e66481b79"
    sha256 cellar: :any_skip_relocation, monterey:       "2b666760fe64123113a10345c24a80603571d1940ebf861c697499111950e7b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7189992ca077dfd226f1423c4159ad0532cc188e61cdda5c8bb810cf980dbb"
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
