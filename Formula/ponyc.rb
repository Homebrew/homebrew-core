class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.38.2",
      revision: "eb556003cea6de4eb064ca696530fc21956051ee"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4f37d6a1accc3d01b056a555cc16aa76fbf86b1a2121de313f484955d1eb165" => :big_sur
    sha256 "5328a2550e89aa15d68a4384327fe4ce3446dcec16b81bba1e0f6316f5b651a7" => :catalina
    sha256 "f2ba99266833d78cebaabec60a3e05961360f5c66cb966767e5db88cad2c9b35" => :mojave
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
