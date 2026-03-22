class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.61.1",
      revision: "e976cc216f235bace72e2837879508283fbb2d40"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "94b9f6ca0821827751a52c8dc7d7792d5e1f24d17beb923287a12e59412949ab"
    sha256                               arm64_sequoia: "3bccf44a9fdc585be496ad425f010f4e5e02509fba3dbf52336f6d275785d979"
    sha256                               arm64_sonoma:  "fae7af833bf1e1785ca677521c9256f9e377dadec34b02ee5a0d7df6976a6ba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1ac91056f007409b97dc695ba1b8b1f6d5e02dcc9765edaf7445c2bb3df9709"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d679ed55fcba57e6996ad7422e09abade995aa574beb6657ff4dfea4967697d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f3814b6ebda2e5f76ca12d85bc2d95a392243ff5274fce8312cb2d441c033e0"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport zlib libdir propagation for self-hosted tool builds. upstream pr ref, https://github.com/ponylang/ponyc/pull/5039
  patch do
    url "https://github.com/ponylang/ponyc/commit/8abfa19aee61a68627488095a2adbd4edfbbb986.patch?full_index=1"
    sha256 "3d4becd4ee7ea1a49a1ff3f92a7870eb7b314ebf93711bbea70fbf894fb29973"
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
