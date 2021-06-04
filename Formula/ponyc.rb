class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.41.0",
      revision: "c0dda326eb1faf0ce67fb1bcdb40430e7a8a807a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "76e24d984ed62f6cda6e06825a44f16dd8aa983a6085fdc5fc183d55a11a8280"
    sha256 cellar: :any_skip_relocation, catalina: "093e481ba250758aa8f9805d930783411566cca560fa14b8f40294a7fb75d87f"
    sha256 cellar: :any_skip_relocation, mojave:   "70e5f4c0d67ba04a7f0986bc2a13e6778bf45dbf78cc831b832cde9bfe1738f3"
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
