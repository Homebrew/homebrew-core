class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.63.0",
      revision: "dc7f4f29b944a3e8f0d408586be6e0cb5e68a57a"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "803f7ee636083e1e14a946575666518b5aafbbbb056dae22572ad799345ae4aa"
    sha256                               arm64_sequoia: "795e4dee4b2996fef1796be8c7f062029a0418a5bbc80a61498bd56ddfc927ab"
    sha256                               arm64_sonoma:  "9dcc226ebbce529ace8259bdd4b1e72f181585815f59b349a793be34e2833cbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "6de78bc2ff85b7292de263e1f1270185fa16dc3823bc75ceb676364124aa04cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65cc66553eada40c760f6665b92d2fd1d7eedcf15f780581fc483ec20cae6891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062b1319f622f6c8b91cd9bba6d4b994ed52dbef2419ece24ccd95972126df46"
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
