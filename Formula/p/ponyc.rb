class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.58.5",
      revision: "0d607b5f1fc7badb8c83a3ebf61b76c70b128894"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7d856824ad5ebd02852922ee5700c6b93d8f745c8974db5522b707772db60d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67f3dd596e2c63c86b6fd65d0c83b6e999ddaab62bb62cdc0da0527f3723d3cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b877bcf39456ae61aa2c8c9f39c725ea3c0ceb15ea1545bb303f0ba17105581"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5a75887dac274c00d0461c8a86dce6442f49a1e3599a88ab9c895bc0830e7d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e78012c7147a61f1f9e8787842d22ed098332b64893aa519fe00e1812082fbb"
    sha256 cellar: :any_skip_relocation, ventura:        "3a80604532c91626de497391ebd515b618428a3bd54e5aaf18cb307579696599"
    sha256 cellar: :any_skip_relocation, monterey:       "d505f85d42bf600630ddcad5f435f6a5165e68b47b08b450e1f0e33229b16850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bd122a559c551a123c20b05d58fc219be181d07079534f2ac800913f9de7d9d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "zlib"

  # We use LLVM to work around an error while building bundled `google-benchmark` with GCC
  fails_with :gcc do
    cause <<-EOS
      .../src/gbenchmark/src/thread_manager.h:50:31: error: expected ')' before '(' token
         50 |   GUARDED_BY(GetBenchmarkMutex()) Result results;
            |                               ^
    EOS
  end

  def install
    inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\"" if OS.linux?

    ENV["CMAKE_FLAGS"] = "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"

    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    # ENV["CC"] returns llvm_clang, which does not work in a test block.
    ENV.clang

    system bin/"ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system bin/"ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
