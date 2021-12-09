class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.45.1",
      revision: "24ed8367791520f8bd68883305ba79ef5ddad589"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d3a26ca61e0fb9fb1cd22f006a98c3773731f677066e254fbf312678ba763f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a53d2ac94c65485805a31d48217faf1972b612ef59d011cb8c1e8759225347bd"
    sha256 cellar: :any_skip_relocation, monterey:       "eee4ea3bbe1a994f3df2f9b8846c6b9ebe2a06e931b471fd0d037e456b4f9213"
    sha256 cellar: :any_skip_relocation, big_sur:        "c240a884c1cd385a565da1d41dab923b52d15f40c425299279535150f999b2e9"
    sha256 cellar: :any_skip_relocation, catalina:       "02d1fcebb37d7e6985ef849b699da1376c6ff6c0899232620b9d687c65cbf5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155bbc527fd280a89cea1353ec95fc24d7d36b9220b0c6832c8ef46ca30fd08a"
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
