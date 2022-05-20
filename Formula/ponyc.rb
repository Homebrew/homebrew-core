class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.50.0",
      revision: "54fe89ae70c553d03391137ae2d1e83724688728"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c48aae8ae4bf42ef3acf91740991e7e5480b375bb292a2b08c1d2f352bdb7bae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f52221e2e3fb2800263c9061014492931448fd10f78106ecfc8caf5335884e2f"
    sha256 cellar: :any_skip_relocation, monterey:       "c557b8fb8acaa1cb92c792e1c0380d6d16ee13bd111c8b354a84a303b2223f23"
    sha256 cellar: :any_skip_relocation, big_sur:        "eef39e925c1d264f5c7cf4348d6827ce6c6a9069e85fa43a2dd274d614fbcfa2"
    sha256 cellar: :any_skip_relocation, catalina:       "a175472a0ecd593481be87c8541e62092344b7ba78928c732799c5a313391b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ce3ad30da7d3a2079e33d11543b3f68037f0ce6da214427431b7cb20b69ec7f"
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
