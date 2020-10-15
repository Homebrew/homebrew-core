class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.38.1",
      revision: "bba16525b41bbe9f05490e80396b935f06b894dc"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc1a3e92cdf2332a147126ea2ce4031fb6856e3f192152ae11190b29c63e723e" => :catalina
    sha256 "37cd9f8fe62fddafd4798b991598cffb36a446b4c5d153e6a4dbdf6b79e95713" => :mojave
    sha256 "299a27feca612c8d5dd6beb65e37ae16d8b259c1f9caedcb5d6b061a30f49dc0" => :high_sierra
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
