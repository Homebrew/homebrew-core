class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.63.4",
      revision: "3beebc2ab1972cff9024907dbeb1275b9fd9bab9"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "06a634b2fc8a860afd7c516f3aadc15b89271c80cd08092383fcb4ea2c402cb2"
    sha256                               arm64_sequoia: "b7fb49a0750d3dbb1c5c6de0b991fa5eb22de0c6d23d1ac2b7ac8928ca45d3c9"
    sha256                               arm64_sonoma:  "5d6e5eeffcfe0dc5ef65f084b78bfbbd5f66f5a4211bcad2ac87f11a70dd2550"
    sha256 cellar: :any_skip_relocation, sonoma:        "9304b6288b9c0340bdbe939c9bc6ae96149b0097033368130b0a5db00455efc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2ab6230f935dceb6f461861765135dc072b02184b95f3e0a35650cf9d12274c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ac5ae95daffd39fb8995980a1c0e475c8ccbbd48a1c244a580df61f75e5d70"
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
