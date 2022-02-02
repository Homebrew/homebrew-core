class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.47.0",
      revision: "79627611b5caa9f413851a05ef43a3eb0f82747c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81f4db3aa80402a035d2d5cc7882f19c1e089ba3e332f0201a5ae58b266fda0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8361582373a7913c2e9cd9166a120855c38a38b761845e4111aa8ec3bf9f9dd9"
    sha256 cellar: :any_skip_relocation, monterey:       "bff15e5ebafa2e38afad93e4c3b6a78c0e522a2c7a9b3f8dfec7ae2292bf15d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c681676424c01d9438063ff23ae1ca1b54959d014489a018619254e9662319c"
    sha256 cellar: :any_skip_relocation, catalina:       "11364110802c38b0c5cc9de76001e4c8fb59f455b7e52ca688a6cb081e31df0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d89a2bf2570fbaaf92a81fe51be4326893dde79b6f707fef734c096f97a49836"
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
