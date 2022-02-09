class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.48.0",
      revision: "367815b900a914ee385f958452e07f6e046ce00a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1645f4eaadab03a24705be15a1350007a375040b3ccd71e4d7b7fc43e399f84b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1e34b2f4237dacc80ddcf3eb2c8cfc09277990edb6cc104a518d116f2e89e20"
    sha256 cellar: :any_skip_relocation, monterey:       "82154810c921a8f10a7bca4c304a34fb70a48fcf642d623bdced7dc34d8e4330"
    sha256 cellar: :any_skip_relocation, big_sur:        "780fa5e4f22a6cf5d3af56a74ff4dba9a70f79668cb86a6b7eea1b0db1d8854b"
    sha256 cellar: :any_skip_relocation, catalina:       "9fcea4a7a4e31f3f984a1298cf584e7086cd171d30cc13c70941967c24785ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63387ce10637660df540920a178cc8b4c4bb9e4ef993608320b47ca0f9703f98"
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
