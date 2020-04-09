class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  revision 1

  stable do
    url "https://github.com/emscripten-core/emscripten/archive/1.39.12.tar.gz"
    sha256 "b7e7c6918055a2a36c75ceeef27b507198ffbf590677cf82b6b3759c4e0c474d"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp/archive/1.39.12.tar.gz"
      sha256 "af2bd0d606e081492c58289742fc29a41d0ea6daabfb80fbc01a804a447b3ef0"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang/archive/1.39.12.tar.gz"
      sha256 "c52b2ad9827cb92afe5f7b5d185420aa971b0e91b172fd1966a4f95f10b8a236"
    end
  end

  bottle do
    cellar :any
    sha256 "46ca40e8225f32894b37a290beec3b862e6e8be5e04b7c4055a81acc58d727c7" => :catalina
    sha256 "a43f7e3dd5321d5da99f84325c5a8834c319d355aaa967a18e1432883b1820fa" => :mojave
    sha256 "93f372f1480530cff3f20c32806b04c5d86298ba8ec48e42727139352789b2cb" => :high_sierra
  end

  head do
    url "https://github.com/emscripten-core/emscripten.git", :branch => "incoming"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp.git", :branch => "incoming"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang.git", :branch => "incoming"
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

    %w[em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons].each do |emscript|
      (bin/emscript).write_env_script libexec/emscript, :PYTHON => Formula["python@3.8"].opt_bin/"python3"
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
