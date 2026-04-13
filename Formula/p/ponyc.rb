class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.63.1",
      revision: "62fd808a211978c37b46fc612ca8c209d2eff0d3"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "9b0b87d8c8f20139bef1e25012336a0f047f05548a8d2319215fc7a475ce9f3c"
    sha256                               arm64_sequoia: "a9edebc2bacf762fe966618b035622c46c4c938b47cb444e31274475c7878e09"
    sha256                               arm64_sonoma:  "ca1abb07dd07b532eaf6ed277ad74830ec474d695a2955bee4e97947f18db92c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7518df7522d6ff4383899a55600f55f269a9c20f5058ecbb42f370b9f14c465e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c67fdef3d8f472a1c7c4015c91fbec44dc3aeb7ddcdd89318093640f5e8fef7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6fab41ba1c4125e51c738bc36621d224f80833ddff0b957611dce72c380133"
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
