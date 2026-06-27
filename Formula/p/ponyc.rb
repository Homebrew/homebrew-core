class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.65.0",
      revision: "0331d45b39625e51b83acfebd39746d78df56e59"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "a07bd9848e5eda6ac8f5a44b57540d1914abacc50346aff77e3884c4cfc6332e"
    sha256                               arm64_sequoia: "87bc469dc9d5e6cc834dbbba64de11122a03f03a8d2c949dcdb4f6c5f1c121c6"
    sha256                               arm64_sonoma:  "e42cd8973f41fd3d450a3e4c656a2f0b86285cfc5304a9cb61a347ace2bedf93"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7da7ae711d31f36da329e5a561f60cd28f060bb55ceb09f19c04c7499ba83b0"
    sha256 cellar: :any,                 arm64_linux:   "2a2e95c431742a0d6bcb715872c0abcad10cf32ff7204ed723ef41f2efc24582"
    sha256 cellar: :any,                 x86_64_linux:  "4ba80ae5564f87a10712ea1216de2dffe575fcb74c36d900171fa0ba19eddc7a"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    if OS.linux?
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\""
      inreplace "lib/CMakeLists.txt", "-DBENCHMARK_ENABLE_WERROR=OFF ", "\\0-DHAVE_CXX_FLAG_WTHREAD_SAFETY=OFF "
      ENV["pic_flag"] = "-fPIC"
    end

    ENV["CMAKE_FLAGS"] = "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"

    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    # test ponyc
    system bin/"ponyc", "-rexpr", prefix/"packages/stdlib"
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
