class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.52.0",
      revision: "a48b9ddff93472395bda01142abe8ed9a119bc3a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51ea615b355a4ac53baccab0a53fc47f1ea1e8d012d5e7569d8d8158643e1569"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b52a582cb771a2bb4d147c5448222d59648c1a820448663ef0c66ca4f9a226"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12297ff136d3e189968dfa433583658b796a576cd58ee8bfc1c4e9a06e40baff"
    sha256 cellar: :any_skip_relocation, monterey:       "0a5e6aa740d20d032923b138ae9480bfa56643d8fa5a99c27f937603cca97e39"
    sha256 cellar: :any_skip_relocation, big_sur:        "d464944f8214cfb2d9df2885b5e2fd887920916baddc24a63d01979399fa7876"
    sha256 cellar: :any_skip_relocation, catalina:       "2eb4c9d563246af7defc953ae147a0292c89ec98c52fb1dded91beab2080a5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b89c7e3f911e7bf95523760e7da330270025ad0ffd1ae71cd25af648573f725b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

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
