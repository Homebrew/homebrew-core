class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.41.0",
      revision: "c0dda326eb1faf0ce67fb1bcdb40430e7a8a807a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "592d31d1803e8a58534b842466e2bbf5235894b4c02c3ca83c9bea3b55cbce95"
    sha256 cellar: :any_skip_relocation, catalina: "497cc7a15b5856a879f734ec4b5cb0979e2c5d47f995c34597a18480a2d84081"
    sha256 cellar: :any_skip_relocation, mojave:   "8a4daff68af70d89ef1cebca9e3116baec9dfaca31cd4abfa74926ce538f515a"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    ENV.cxx11

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
