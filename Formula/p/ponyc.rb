class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.78.0",
      revision: "494bc7148f155f418d05814ffe12be01a10307e9"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256               arm64_golden_gate: "ab4e55c1ae0c14ec6d49d88c3d2e4d2fd6660a7a1444f890d708b420da7a5505"
    sha256               arm64_tahoe:       "491e4e6c0f53cc744bece5928622bea9826843b754193298c952a9d226014470"
    sha256               arm64_sequoia:     "106cc09557236c71783381df67fad36d8b53cc7900cc06f8ae38dbc1a0130746"
    sha256 cellar: :any, arm64_linux:       "1f768a635d378a80d769f68235e6a6918931b34cbcd878eef5ee9ebc6fde3c5e"
    sha256 cellar: :any, x86_64_linux:      "0d85f143fd3532bc6f3b3077c1ad32e19d4df3356f8f26357ce72486c6af30f1"
  end

  depends_on "cmake" => :build
  depends_on "google-benchmark" => :build
  depends_on "googletest" => :build
  depends_on "openssl@4"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    pic_args = []
    if OS.linux?
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\""
      # aarch64's small-model GOT overflows with the default -fpic
      pic_args << "-DPONY_PIC_FLAG=-fPIC"
    end

    # Use formulae instead of the tarballs `lib/CMakeLists.txt` downloads at build time
    inreplace "lib/CMakeLists.txt", /^ExternalProject_Add\((?:gbenchmark|googletest)$.*?^\)$/m, ""

    # Build the vendored LLVM that the main configure step links against
    system "cmake", "-DJOBS=#{ENV.make_jobs}", *pic_args, "-P", "lib/build-libs.cmake"

    # ponyc requires a lowercase build type (it doubles as the output dir name)
    cmake_args = std_cmake_args.map { |arg| arg.sub("-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_BUILD_TYPE=release") }
    system "cmake", "-S", ".", "-B", "build/build_release", *pic_args, *cmake_args,
                    "-DGTest_DIR=#{formula_opt_lib("googletest")}/cmake/GTest",
                    "-Dbenchmark_DIR=#{formula_opt_lib("google-benchmark")}/cmake/benchmark"
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
