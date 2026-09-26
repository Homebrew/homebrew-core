class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.72.1",
      revision: "de5eddd973a48689ceedd12d24bf42358e5694d5"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256               arm64_golden_gate: "4374f190c6d81bd63c78385f47207e2f2ba0845337da24c58a9be53610fe4fc4"
    sha256               arm64_tahoe:       "4dde20673966b91111b10607708219b1a65c5606d30322c683a83c293543a7ab"
    sha256               arm64_sequoia:     "777bc96467a38dd02ea3cb89f93ab3553834206258ed7624535c4c7c03e3bb1d"
    sha256 cellar: :any, arm64_linux:       "a7cbfc2f2bef1d6fdbafc0e91d9a48946d103897f4e44658cbfd353784bc5fbd"
    sha256 cellar: :any, x86_64_linux:      "7ed360ee1c8c14b63ff829e727a76940dfc9a1a64e15c7ddf3ea5e4841212a55"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  patch do
    url "https://github.com/llvm/llvm-project/commit/b8007a8e4020b8bca2b12e941660e10bf5bf6716.patch?full_index=1"
    sha256 "e41e300eb6f5cca9172ab344e572c3fb24f0d05885ae23dd7cb4f9c2528839f7"
    directory "lib/llvm/src"
    type :backport
    resolves "https://github.com/llvm/llvm-project/pull/222721"
  end

  def install
    pic_args = []
    if OS.linux?
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\""
      inreplace "lib/CMakeLists.txt", "-DBENCHMARK_ENABLE_WERROR=OFF ", "\\0-DHAVE_CXX_FLAG_WTHREAD_SAFETY=OFF "
      # aarch64's small-model GOT overflows with the default -fpic
      pic_args << "-DPONY_PIC_FLAG=-fPIC"
    end

    # Build the vendored LLVM that the main configure step links against
    system "cmake", "-DJOBS=#{ENV.make_jobs}", *pic_args, "-P", "lib/build-libs.cmake"

    # ponyc requires a lowercase build type (it doubles as the output dir name)
    cmake_args = std_cmake_args.map { |arg| arg.sub("-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_BUILD_TYPE=release") }
    system "cmake", "-S", ".", "-B", "build/build_release", *pic_args, *cmake_args
    system "cmake", "--build", "build/build_release"
    system "cmake", "--install", "build/build_release"
  end

  test do
    system bin/"ponyc", "-rexpr", "stdlib"
    (testpath/"test/main.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin/"ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip

    # test pony-lsp
    require "open3"
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    Open3.popen3(bin/"pony-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
