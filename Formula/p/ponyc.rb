class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.66.0",
      revision: "e7d0d0bcea543f8978ea7ad7987d63f03908de50"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "4f07eecf15dda3351087de24f0fec39bac44170580434ce071ee972da52fd77b"
    sha256                               arm64_sequoia: "cfdc631a3af23a6a7aa52be789e842b638b42dd967ae1a60b10a9034ec5ef59a"
    sha256                               arm64_sonoma:  "fdcd419f7bec05b26a020587819c7c79b371c5d3eb7b48e589f32c3d04bdf6e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8822d3890e10a103a77054b559ddcfc2464f4c37a9407a2cccd6a5bf284fe8e"
    sha256 cellar: :any,                 arm64_linux:   "7c81499a7bb7765442fff906fb424bff65c927662e2905a4847030c96402aea8"
    sha256 cellar: :any,                 x86_64_linux:  "e13867f9f713689827299ca378a6cb925dc73c49e309406bbe12a844d7682080"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport to fix shadowing system headers
  patch do
    url "https://github.com/ponylang/ponyc/commit/bae6fbbf9e6e8c55ef7614999e4160f553359de6.patch?full_index=1"
    sha256 "dbe4bc81eb02958da8d5a500a5c28c0bf9ec923186bc557a230fdeadc2139914"
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
