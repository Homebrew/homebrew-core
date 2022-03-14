class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.49.1",
      revision: "c09be039cb46fd05623d83e365b4eaf164171dab"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21f8357dedfd3841b4dbcbfd7db17df64948077da69839220fead20a4759a729"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20eae00574927269ea290d70e02deaa21a66408e5a29f3ab1116f120280b06ea"
    sha256 cellar: :any_skip_relocation, monterey:       "2688e94981915245b3c5fb87cf58601a6df4f77a4c862f712085fedc18b72789"
    sha256 cellar: :any_skip_relocation, big_sur:        "011c65a48f70a1f0774a3a41b28d5357b648e0b401c7159c776fe8bd3934ad25"
    sha256 cellar: :any_skip_relocation, catalina:       "e614f1f04cac6cca049dee40005d2b42c96b65af1a7672701c5b21338049244e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80c492a82d1384bde8395b7c1fb8794cb5262b2f962ded7f25a90a199778e077"
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
