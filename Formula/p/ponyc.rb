class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.62.0",
      revision: "cacb1f5985e0f18573f0533a1dbe949ab21fca36"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "58a17793c0d59c6cc2dd33a7d9ba345caeb252e620e8d2d45487f8b27626807e"
    sha256                               arm64_sequoia: "82d9c664d8a1cfa96f62f71a85314ae597129a40fde52b0a9d8a41643476592c"
    sha256                               arm64_sonoma:  "3390884c780240e84732b12e47425f09d57dc2cd4795c2418ecae8b123accaf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c842fc636705a9aaab74b6ec1e094cdfffbb8344eabe6134833295916eea75d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3a8ed9ff8db5815d5d2e8e8bbbc5954969a377602bf858cd9e389c726efd9fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb6b911fa42a16d8b71bc6e4680e074d7ba20af733a6592030e5d9b852cbb2c"
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
