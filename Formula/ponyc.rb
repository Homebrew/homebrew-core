class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.39.0",
      revision: "85d897b978c5082a1f3264a3a9ad479446d73984"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b947aefd9340f18f5a25790bc66525b97d6906cc7a9cf1fbde33bc2cd4392832"
    sha256 cellar: :any_skip_relocation, catalina: "ac79c2dd8d777089cc460b82f8904b9025e78b2c01e3dec427d4e0455e30e22a"
    sha256 cellar: :any_skip_relocation, mojave:   "4ff3fbf05cee2dc1ee38bac6044802f1b2aba9e44e0bc0116d2b63e5122e5be1"
  end

  depends_on "cmake" => :build

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
