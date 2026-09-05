class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.70.1",
      revision: "02933d6977e8dc471e0f45cd769e16836a5a5d36"
  license "BSD-2-Clause"

  bottle do
    sha256               arm64_tahoe:   "ceae94f2d966857087ededabf65d60e5d8fb65fe996ec61465c65aa36f3c2b7e"
    sha256               arm64_sequoia: "186155650da106b5160e931d9656f9b62d37170dbc5c532ae44986d238463ac6"
    sha256               arm64_sonoma:  "41438fc8a1e101b0d6ad29b7f50f8e8945b287c29f7f607ca426f988c97f0f4f"
    sha256 cellar: :any, arm64_linux:   "d16027bc1fc05dee004b792b97dc1cd14fc8ebad9d11aa0a37b2571834f890de"
    sha256 cellar: :any, x86_64_linux:  "446847a9ed7e6d2beee490df27c7a22e3e35d42d61cf983d68df4d9bc7838efc"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
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
