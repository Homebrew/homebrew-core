class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.58.6",
      revision: "41be76e6a9a04fbded3dcdcbc4ecad329c50b383"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98438616492c5fbcbdf8e909975f2632b3187eecd6f75064f372249757b4734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2636ce85f414bf4b3cae31d52319a601afeeec7c5230a51b7cb1697c952a095"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e58162e39f7915d9207122821bc1c891514931ca62fe8120a76b1b8f598b6d46"
    sha256 cellar: :any_skip_relocation, sonoma:        "47170d0364e39d66d157e900899ac3f11ae4b5894fac7b316fe384b90ead3ea7"
    sha256 cellar: :any_skip_relocation, ventura:       "d9be64ca274eb039c36cb2b7932b0a8f58dc6e1111af2eb191eb96407880209e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8eb0d99c5f2dd944761817f36f348ba6199dbe293646203095bb12fba1dbafa"
  end

  depends_on "cmake" => :build

  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "python" => :build
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
