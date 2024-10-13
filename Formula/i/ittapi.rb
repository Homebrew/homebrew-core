class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.25.3.tar.gz"
  sha256 "1b46fb4cb264a2acd1a553eeea0e055b3cf1d7962decfa78d2b49febdcb03032"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0eb47aac43b90656715526826788302f478fefd2cd9b022a71c9ca224ad624e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "864d3f828eb1ae959585364d3c31937c951668f4a8d93c43b859da1b829b7a44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd02e6e759e5a65863acb20f3f21ea4643e30f762f4673a5305d324183ab148e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32a4854bf00d45a310a511ff1686cf1a356dc2563ce7999baa90465b285295b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d8b9ae4f59e2160df13d155e416f476e24050e79875199b77471a74f6e5b6dc"
    sha256 cellar: :any_skip_relocation, ventura:        "8da07bcc001f2cabf65e8e53c79fd518bedfb688a95babefd3e9371cfcc4863c"
    sha256 cellar: :any_skip_relocation, monterey:       "687d2971980df9809b556895bb31b77f01a255128b0efcaff918c60c5194c5d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b68352be50966560ebde0f6b9287da348168aae0cc1669a60793ba9eb9057e6"
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
