class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.44.0",
      revision: "48084fe40e9f95fa9d87d3782b0cf4acbdd9bca1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "cce001435d5e456402444206e379d3542b3d898372514c8b450f1ea235a5be20"
    sha256 cellar: :any_skip_relocation, catalina:     "0c93b907b614ed0f3fc68d11b91f74e4594e5ffd86896d72f35109988ffff380"
    sha256 cellar: :any_skip_relocation, mojave:       "e46e8e63c97ba8481300376e641633eef8054f64923b9e40fbaa840de9ada354"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e3e2808b2826c8f243f2d6391df212deb8834e0cb5060c0e79a9ec4c7b6997c0"
  end

  depends_on "cmake" => :build

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
