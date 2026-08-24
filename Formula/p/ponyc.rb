class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.69.1",
      revision: "38f9f11dac16623aa322c5fb56545c69f97b3517"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "76afbb26b05e1b73a9f579e35a217791ebc283af8c930217bac57f7520debd73"
    sha256                               arm64_sequoia: "df0252865b4ce4a609e79d1835f4753ea6436e2e00c4ceae72978c82948fd6b6"
    sha256                               arm64_sonoma:  "6f336f8364e65878d63c9ddb10c995333ca5276abf083cda88e6594c194cc324"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bb8b3351734e82657126ffcc72f759a669906ee67a5e674ec15bdcb02859027"
    sha256 cellar: :any,                 arm64_linux:   "a21a2854aae8d0413cc1b3cf48221a83f6f24b5a761adbe43d54a613178b8113"
    sha256 cellar: :any,                 x86_64_linux:  "56ade3d4a0a4d466f849b9a8f9e71f25617daf5fbe92d2487b7df2a7218a6ca7"
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
