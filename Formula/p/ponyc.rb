class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.67.0",
      revision: "f849700abc56859745b10be897244d0200fdf4dc"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "86b89eda5dacdf25edb7d26bca0569b12d747f249f5d5885c0d7500e8870b52b"
    sha256                               arm64_sequoia: "11f2e5cf3753cd3663fe7a97f3f42691cbc9e4f46b7183f2335fe2423723a5e9"
    sha256                               arm64_sonoma:  "2964d95ddf9e22ec7efde128faee9a4202ebee9b49f21a602df4724cf3ce6f5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8996eb9f811ae9185bd960f7066f2a6cd11d9eb81981c309e78384ea3a904c05"
    sha256 cellar: :any,                 arm64_linux:   "23bdbdbd2b618811cfc7c266b38172eb874b2801ac7faf766f4afc00b1babba3"
    sha256 cellar: :any,                 x86_64_linux:  "6d606efd9cc2969c70cf35bbb85f0be8beaf35e265cbf8241c08833baa777721"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix install of self-hosted tools on case-sensitive filesystems
  patch do
    url "https://github.com/ponylang/ponyc/commit/fd1db495cfb333754434fe141fedc32c975577a7.patch?full_index=1"
    sha256 "accd264a743c220c681439118c1df88d8da427a3931329e237f21cb5c3549f7e"
    type :backport
    resolves "https://github.com/ponylang/ponyc/pull/5752"
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
