class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.51.3",
      revision: "b9de0c0d5595343498c4fcaa9dddcc4724adea8a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f699c8596078416cf8f8511857c9d325195c2da8d8ea55339607b6860ef6128e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ab996163bd550bb352277b6679b98620eea069ef63519236843bfe6bc120925"
    sha256 cellar: :any_skip_relocation, monterey:       "254136133bab7da15bb052ed7be42423f96624b7a607b79ace85622640fe6c59"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e5288daf7f205cabef9db0f0a3e1a570a386134d3d2c9f329e479c1cf75fda2"
    sha256 cellar: :any_skip_relocation, catalina:       "004a1c32bd63e774c20c07c3a7738ae731e891e7f72484b77291d2fe870729cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "285b16250d89b9fad370928e45a3002859fd5ff44b4e3c0a38106e66281e6d5c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\"" if OS.linux?

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
