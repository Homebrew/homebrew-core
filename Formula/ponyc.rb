class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      :tag      => "0.35.1",
      :revision => "579475721b14487e225e57a64ecd44781d244b33"

  bottle do
    cellar :any
    sha256 "b810571aff7518d81ea773d07f0f8fd1def25f4c795a664b1c770330d07069a8" => :catalina
    sha256 "2adb6b736e5ed544c6d8535e31f5c7e19b47e6eb57cd34ad6ed3c55b29f619f7" => :mojave
    sha256 "216889f9856cfb4da8bb46a9aaac3af38e4f1f8f349b5928645ea0d266231b8b" => :high_sierra
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
