class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.46.0",
      revision: "afda8d1408bd4fc6ff420fb25e80f7ee91f3933c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70be28d7b28eb267ca45958fccbafe36595e4b7729fb6aa336dd2a8f940e0e59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b37b0c1253f6ef790cf33950cb427eda1ce5130cc03806d70b0175247cd6cd5a"
    sha256 cellar: :any_skip_relocation, monterey:       "e8ed4f83881c6a48b3a0d2f77a5917b02d24f5636cf763312f831c0dcb4854b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5d9cc3d2da712ea7a0947406d452fc7e85a31bb9c55643d4790d9f8e3f6f0bc"
    sha256 cellar: :any_skip_relocation, catalina:       "219cdfaf35fb814262f4c7296079a65db36acbc51ebc53a1feebb121e58a637c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32714bbd1c4aa2377226c5782fd9365e2f8d2237c765581af803074174a2703f"
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
