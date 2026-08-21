class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.69.0",
      revision: "c282faa4b4856bb6f31ab38d4ff510a1a1674af3"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "0341c8ce896d6c1d9c6df70b296f3edfdc76ce03dafa9755214882e867f6c169"
    sha256                               arm64_sequoia: "e4dd5cdc213c1fbb014ea56de5f6aa8345e7327661efb79e0b181bb7a6a75943"
    sha256                               arm64_sonoma:  "9d4094e3b3affb87306905dcd1755783ad237db164b5e764500d6979c6bf5f57"
    sha256 cellar: :any_skip_relocation, sonoma:        "b874d15fcb5598226e4333339e02e0debca68cfa2bf55749a03149924bb935b9"
    sha256 cellar: :any,                 arm64_linux:   "1f9ab782bc28ea437833f064fcbb90bb349dd29f1121219cf3dc85ca13a16876"
    sha256 cellar: :any,                 x86_64_linux:  "912f94d8c44d8f70e0cc5d63e1c8c78574100ecb2165d4bed8fa04205994572c"
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
