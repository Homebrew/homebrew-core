class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://kripken.github.io/emscripten-site/"

  stable do
    url "https://github.com/kripken/emscripten/archive/1.38.9.tar.gz"
    sha256 "bfb7e7f7a4f5c0397a83fa411b2ef380b3694a2457ccb111fdb6120a3480ad58"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.38.9.tar.gz"
      sha256 "177df2b1642ec728305fbddfb45fe23f851ad41c96229172035a6fa707be87a2"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.38.9.tar.gz"
      sha256 "f05a30fb8bee025cfa97b74a8c0ca2c4345650fb423f77811e447a8e525b26bc"
    end
  end

  bottle do
    cellar :any
    sha256 "b37f1b02a358696f91f39072ee4f79e7e43f0f96ec28f6a42618477fc6a60ee2" => :high_sierra
    sha256 "5d628116bd71d339fa6868f21cf783448b27a3a396d4812587f57e3adb5bd3dd" => :sierra
    sha256 "59a9474fc95ffd705bb5dcf12d888284ef355c20eb6cd08d87e7daef885333e1" => :el_capitan
  end

  head do
    url "https://github.com/kripken/emscripten.git", :branch => "incoming"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp.git", :branch => "incoming"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang.git", :branch => "incoming"
    end
  end

  needs :cxx11

  depends_on "python@2"
  depends_on "cmake" => :build
  depends_on "node"
  depends_on "closure-compiler" => :optional
  depends_on "yuicompressor"

  def install
    ENV.cxx11
    # rewrite hardcoded paths from system python to homebrew python
    python2_shebangs = `grep --recursive --files-with-matches ^#!/usr/bin/python #{buildpath}`
    python2_shebang_files = python2_shebangs.lines.sort.uniq
    python2_shebang_files.map! { |f| Pathname(f.chomp) }
    python2_shebang_files.reject! &:symlink?
    inreplace python2_shebang_files, %r{^#!/usr/bin/python2?$}, "#!#{Formula["python@2"].opt_bin}/python2"

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
