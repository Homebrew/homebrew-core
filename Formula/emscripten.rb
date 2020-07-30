require "language/node"

class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  # Emscripten is available under 2 licenses, the MIT license and the
  # University of Illinois/NCSA Open Source License.
  license "MIT"

  stable do
    url "https://github.com/emscripten-core/emscripten/archive/1.40.0.tar.gz"
    sha256 "3a248111308c3b8304f2430f6118d7c3723c8f755ce85c2f61b64791519e86e1"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp/archive/1.40.0.tar.gz"
      sha256 "127a649bf35c7fdb94cc75b1eecd45595ed265b9a9f7de6a633f3eeeb4249110"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang/archive/1.40.0.tar.gz"
      sha256 "51d5a541bde99fca58f46cb240cc53dd00e693abfecf79cbb19bc91bd3d87fbd"
    end
  end

  bottle do
    cellar :any
    sha256 "1c4d040a8bf64d3c8ba9694e63508c1a01c44d83bbae37d7fd8a166cd1638a68" => :catalina
    sha256 "3e8c66def035c7e7eea99d11f0c37ae6b18c1c88fe5ce070bc7660762f2e6727" => :mojave
    sha256 "5932fbf012e72a11c25ffac6d9850fb20b12a266bee96f3f54bff2be5554d96f" => :high_sierra
  end

  head do
    url "https://github.com/emscripten-core/emscripten.git", branch: "incoming"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp.git", branch: "incoming"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang.git", branch: "incoming"
    end
  end

  depends_on "cmake" => :build
  depends_on "binaryen"
  depends_on "node"
  depends_on "python@3.8"
  depends_on "yuicompressor"

  def install
    ENV.cxx11

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install Dir["*"]

    (buildpath/"fastcomp").install resource("fastcomp")
    (buildpath/"fastcomp/tools/clang").install resource("fastcomp-clang")

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
    cmake_args = [
      "-DCMAKE_BUILD_TYPE=Release",
      "-DCMAKE_INSTALL_PREFIX=#{libexec}/llvm",
      "-DLLVM_TARGETS_TO_BUILD='X86;JSBackend'",
      "-DLLVM_INCLUDE_EXAMPLES=OFF",
      "-DLLVM_INCLUDE_TESTS=OFF",
      "-DCLANG_INCLUDE_TESTS=OFF",
      "-DOCAMLFIND=/usr/bin/false",
      "-DGO_EXECUTABLE=/usr/bin/false",
    ]

    mkdir "fastcomp/build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
    end

    cd libexec do
      system "npm", "install", *Language::Node.local_npm_install_args
      rm_f "node_modules/ws/builderror.log" # Avoid references to Homebrew shims
    end

    %w[em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons].each do |emscript|
      (bin/emscript).write_env_script libexec/emscript, PYTHON: Formula["python@3.8"].opt_bin/"python3"
    end
  end

  def caveats
    <<~EOS
      Manually set LLVM_ROOT to
        #{opt_libexec}/llvm/bin
      and BINARYEN_ROOT to
        #{Formula["binaryen"].opt_prefix}
      in ~/.emscripten after running `emcc` for the first time.
    EOS
  end

  test do
    system bin/"emcc"
    assert_predicate testpath/".emscripten", :exist?, "Failed to create sample config"
  end
end
