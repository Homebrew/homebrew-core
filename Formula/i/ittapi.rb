class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.24.2.tar.gz"
  sha256 "006c0379ea072965b735922c5e01ab0f2a32e288675c200523a59279a03254fb"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49b5bae22386bced73ba2090de7321570b089d3a0f3a166424e39898025b3107"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e283bdba1a33c24d5a7369b5596801746c543dbd789e8da2d885412d5d40d6e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e260645d91cd2224fd37f5c258d7466a4f2e690a6388f9740934527f0b1e749e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20874a9e92cab5123555d93b57cd570089d9d715596d56d129e5d121abd92128"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed6b172a9ab91c886680ee2f1e2d825c02ed088511568dc1f332ae7c03af01f7"
    sha256 cellar: :any_skip_relocation, ventura:        "20d1a8592d9911f40606a5390727ae17c7e60c285b4836933c9d01d642a12dad"
    sha256 cellar: :any_skip_relocation, monterey:       "b3d297d0a59ff7da7a7960fcfc2075342b6b309f1b3b216a97b31317b90c2f31"
    sha256 cellar: :any_skip_relocation, big_sur:        "abf107eab80397eb821930e54b1aff7a65f112ca5fd17bf1d59f2981ddc931d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cac75cf90921f8a2313415e8c2082c293a99cc3c4c8b3a8fa17242bc716c833"
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
