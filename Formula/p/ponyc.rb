class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.60.4",
      revision: "17b87bd708879d66827e56780a0a13601ea82e8a"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7288dc31f830460534f3e6e9e6a663ed2ed9a2c992362c938d16d211ea2e1ff7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e189f5726e29936da00cbb00e62513d4a287d409cc764c269f93f9a6ff5b4b39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43aca5251489b73177f2d7980e9d0b3c031457e71253fcb4502d2b6e2dbec152"
    sha256 cellar: :any_skip_relocation, sonoma:        "c99999e253d92a804e3c93fb02e1e9ad9189c28f8ffdbd2ef4217ebb2f444d37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ca4cdec044da1f75553b8f4137f67eb6687fbde506c28771a21d5a375ad8b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af363926ddaff00352bedd762e54a2766acc92cb849b8f9e49e2d7dacf559699"
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
