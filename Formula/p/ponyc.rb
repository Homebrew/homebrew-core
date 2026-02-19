class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.60.6",
      revision: "1b870304ca4c6d8a098368a3fa32fa302fab7103"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a636d83fd47d1e0cc3bf94e560d4cc9d97df93a86a589bd0e4fbc9a7ec237dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fdcb0c2dffc7885b68162de05d81cac4d8af6a96e78b82d83adcdbbda717614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "741d8ccdfac007ce002896acc782bc5b30cbca76954d3fa8e25afdb0e7088e3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "618e49e9450dbc0dadd39cb99b70032950cf2ca7b43bdeff8730783c5e1e5016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "009e916f95208b4c053b3b8753d14fa74169ffd4dd2363404f119151800480e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fbe9febf895396133a8d801e0aa3998718301b49fa1f242058a22a71e4bb398"
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
