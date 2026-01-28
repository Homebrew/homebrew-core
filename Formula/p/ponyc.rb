class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.60.4",
      revision: "17b87bd708879d66827e56780a0a13601ea82e8a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ac487b53bb7995e41d4da3e816d1678e2ac581817a28eb62c2e347325f70239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3bbc75214d3fb75a693c2bfc4fb2633d6cc56dda92d93db2069880ef473c13e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c4ae708cbe92306ddea79495376682d78b27a84d5f0c2f6741738bc4fb00f7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1acb73969bd4dc9b4ac615e5964619b4dd161b360a77a9832280eaff2b4a1e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0deae9922ecedca2ee066c23f8c72cf218ca0af7c57a2ae7b5acf9036037a977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b422add393d475acf45ab83cde9e897aa9ccb9a966cf91b07264faf1302cba"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

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
    system bin/"ponyc", "-rexpr", prefix/"packages/stdlib"

    (testpath/"test/main.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin/"ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
