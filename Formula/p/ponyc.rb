class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.63.2",
      revision: "1bc3848923f80f353ecae47091faf094881fb436"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "2675ded19fd5350fc5a182ed7c4b316e9fde2e90cc614f994441627228e415af"
    sha256                               arm64_sequoia: "7859daf95944cfbd35ee3d9f1a7f99f64002eada644569ebbc25fa53e862eb3b"
    sha256                               arm64_sonoma:  "958f78917aa4d86560acd0dd882ea458db200f62cb2206da9bec30dae737e43d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ba35295da81da56e90e261c0045c862a4e2201aacc62aad1125bb5c5cdfb61b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c90a4c6122b1d89e68a26ca348100419ae9841114a042ecd90b132008b32d7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "919b220cb54f8a08c7175043d0e5e90c0c2fc36fa4c0682072c58e61a659d0f0"
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
