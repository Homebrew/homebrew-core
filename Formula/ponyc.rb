class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.51.4",
      revision: "fed8b38acb18ccfcbbba7b630d66ccf0975a2ee6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7147d1270bdc149bb838acb247591943108e4a882ec16ada4bff9b1145e8f5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "444dea035081cb04f3ee634b9f76c370273c19fcc2969607c2e6c91010b2a054"
    sha256 cellar: :any_skip_relocation, monterey:       "6eb331fdf15bdcb0f1119f9abc5914117e9c634e4c53b296241d536567d65951"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed3e1d02a7f40bd992e7066374ca1398f8dbff458b393e24bf33274fde5ccc57"
    sha256 cellar: :any_skip_relocation, catalina:       "23ff7b6aa34af4c7af2b972801ba960697a91e54b8c0c8e59393f97acc15f3a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21e2c90baa20aa6295606d7018e9d1a048c1d31b80e39cc38883e46f524d3946"
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
