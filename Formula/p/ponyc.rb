class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.63.3",
      revision: "fa7d7c0a80b4545cf6458091d83d07f48b318680"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "b8afcb5e57074abe867ed76927b7bd05b73708a054cda946773ab0986d583533"
    sha256                               arm64_sequoia: "c337a4acf1d3fa036519e7389f10d83c0eae50807932cf90aa381f0acf4bda22"
    sha256                               arm64_sonoma:  "b207162de0bae62034041003ab9967697d130ce9facbb9c0aeaf5a60ad4f8e54"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3175e2e65abf2e073f2bf87451df2687567f7e410da8e6a23785523975d536f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "409f7ca15b00670fb4e7991c96bab80fd913b4a27ac53985d7c0902ff9dd3b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ece4538e61c90c66fea3bacc259ddb8af5de88f69a08e6a6385c749e7dff91"
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
