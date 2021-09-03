class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.44.0",
      revision: "48084fe40e9f95fa9d87d3782b0cf4acbdd9bca1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "e99e8ae8b4d547ce9cbb7b04a3081e2769495ce52d7637fcb9b3b9506d5100ec"
    sha256 cellar: :any_skip_relocation, catalina:     "2cf969c388b4834880b0a766cdf9ecbf9d8a091ec1ea6bba81d2a157dcb99e64"
    sha256 cellar: :any_skip_relocation, mojave:       "694a5200ac1cb38a5253f4e7f87fed24007a45807048676c463234d65d374eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6b4f18e4af9be02c39e0525b658d630a2db001dac7da0cf059d3c91196a53ce6"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    on_linux do
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\""
    end

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
