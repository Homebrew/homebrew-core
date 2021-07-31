class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.43.0",
      revision: "a1bdb4ca41366ab12e7f108b971b0dc7e17cb17d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f4ce5a5340f946294b1b0ea9d6e24bfb4799a4330d000dd6ebaeff95756ad760"
    sha256 cellar: :any_skip_relocation, catalina: "b096ec2732364f035765cf4bd765fef5fbd2518a55cfb4a36a3f3553091d5fe8"
    sha256 cellar: :any_skip_relocation, mojave:   "ef77a2d24f2e282923446a439554bca8126758963b4264a042ddde3fc203cde0"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    on_linux do
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\""
    end

    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"
    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
