class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.51.0",
      revision: "33746cc3deb5a27c52b1ebddae59378818505fc0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baa616d97e315b80e24f152a865cdd9008b6259c3d63bb00c032646453e328e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e4cc36e3b3b5db37f129b1c1a101ad6da15e06e2a9020c552ac9edd3a070fee"
    sha256 cellar: :any_skip_relocation, monterey:       "c685ea3b05d2dd6906930b3bf22741a35682dcd322c0d107e2e715b1588d9c42"
    sha256 cellar: :any_skip_relocation, big_sur:        "78d92397664a4217258e279d19df9474e065322411599cf2d2d9ea1d53f42d3d"
    sha256 cellar: :any_skip_relocation, catalina:       "a9a8886e1683d5cb9ff789f0b572b78b84df9714bed6aa8f74b9b60598e8111a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72cb44487be0b9e3433e9246db7504860c64e9fa5822e83fcfe076602e68213f"
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
