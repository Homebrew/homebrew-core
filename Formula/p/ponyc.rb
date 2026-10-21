class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.77.0",
      revision: "b48a5d6d6963164f3452f6561ba57e912a177a21"
  license "BSD-2-Clause"

  bottle do
    sha256               arm64_golden_gate: "4f743a3e003b765b81d943f2df716c14233dfc55aa48d906ed2c101ae4498871"
    sha256               arm64_tahoe:       "bc614d752c83bee9ef352ee0a4b4b6b4eed7259e16bf2a8dceb977ac6f4a596e"
    sha256               arm64_sequoia:     "c79204fe7b16fed525ad523091424aaf9826da5c09f61d7c83f35b9ac9d48193"
    sha256 cellar: :any, arm64_linux:       "1c884057780393e290b68f1625f744d38b58fa3c8e5eac026fffc4dd9ad448a0"
    sha256 cellar: :any, x86_64_linux:      "5a39566fe23096e82ecd1901ebba05a7b204132cba08aa14ff668d9c0b4dc5d4"
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
