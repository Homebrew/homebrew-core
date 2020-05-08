class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"

  stable do
    url "https://github.com/emscripten-core/emscripten/archive/1.39.15.tar.gz"
    sha256 "e40f6ba8caca653d5fd5f2d25debec56a8ec48e0409f82dbf1fc677824de1dcd"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp/archive/1.39.15.tar.gz"
      sha256 "d220d1d2529ea26be65ad554233de63613f8e407f6177cd572c56cde44eab34e"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang/archive/1.39.15.tar.gz"
      sha256 "850ff41724a3594ab4eae1008c661b77887cfa06aef24f87667a65924ca22bad"
    end
  end

  bottle do
    cellar :any
    sha256 "dd896b0513c1656182ed73f2dc6c89311dc31342d8491f6816d30a8f93760cc9" => :catalina
    sha256 "ade30a3efddf793239939ddd16a3687ae1298834742431dc2fe20691fba2caa3" => :mojave
    sha256 "21143624e75087220d91962845f810c18e915779a491c1c150ff555af1bf7571" => :high_sierra
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
