class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.io/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.58.4",
      revision: "3fb4864a4762eeae4278686dc2f8f5da5499995d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "debd35a23e20791e7314a8eb45b52fcbe64ea8b3efe0f38f408fd4a38eff01e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d959bfba56c4155fe9c10e7ad7b3ddf496d6986c6d0479251b0d4a0712736361"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c76874d481d206cc674f4781a43fc40529e1f4cbbfb8eef676c36a7c1e1bc6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "005f4d3795380982bb5d0048319660c5cb172623a2d99d6f36db45c28b2063ea"
    sha256 cellar: :any_skip_relocation, ventura:        "67e80c0b92b44a39223512dd22189ced5a9178cae8e15e8b0c9db2cb980d6d62"
    sha256 cellar: :any_skip_relocation, monterey:       "4810de741d81cdaf658421ea79973ae28e3141b62b98e2cff518f7072c4f99ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9704599bb87b773d72e3e79a042dad9ef0a5b850db6e4e8c94283719f3e97fa"
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
