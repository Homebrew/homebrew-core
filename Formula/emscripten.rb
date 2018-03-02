class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://kripken.github.io/emscripten-site/"

  stable do
    url "https://github.com/kripken/emscripten/archive/1.37.35.tar.gz"
    sha256 "901eec1819754d99ba17475126602d30ab2a183d67d59c6b83d653cf0dc7dcab"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.37.35.tar.gz"
      sha256 "247ed1b99e025424bdbd49e19e89223dac7b0f44b6199acd667d99d2fe2a769a"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.37.35.tar.gz"
      sha256 "477bcf6546fccf8e4eb7205ede90005d31d23267236fb757d824b81dbcb5ffd2"
    end
  end

  bottle do
    cellar :any
    sha256 "cb78901a1ba6847628af1debffffc76904d30b40c8e5dc96f0a3be6b31cc7909" => :high_sierra
    sha256 "77699147b1bdd49c811fd0add40188ae9cfb377306f0f5d25b78ba84e3c26f10" => :sierra
    sha256 "98772109bade817d6f16e68f43ee7dfdd36f70c08ae583a8149823a3f92c6748" => :el_capitan
  end

  head do
    url "https://github.com/kripken/emscripten.git", :branch => "master"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp.git", :branch => "master"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang.git", :branch => "master"
    end
  end

  needs :cxx11

  depends_on "python@2" if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build
  depends_on "node"
  depends_on "closure-compiler" => :optional
  depends_on "yuicompressor"

  def install
    ENV.cxx11
    # OSX doesn't provide a "python2" binary so use "python" instead.
    python2_shebangs = `grep --recursive --files-with-matches ^#!/usr/bin/.*python2$ #{buildpath}`
    python2_shebang_files = python2_shebangs.lines.sort.uniq
    python2_shebang_files.map! { |f| Pathname(f.chomp) }
    python2_shebang_files.reject! &:symlink?
    inreplace python2_shebang_files, %r{^(#!/usr/bin/.*python)2$}, "\\1"

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
      bin.install_symlink libexec/emscript
    end
  end

  def caveats; <<~EOS
    Manually set LLVM_ROOT to
      #{opt_libexec}/llvm/bin
    and comment out BINARYEN_ROOT
    in ~/.emscripten after running `emcc` for the first time.
    EOS
  end

  test do
    system bin/"emcc"
    assert_predicate testpath/".emscripten", :exist?, "Failed to create sample config"
  end
end
